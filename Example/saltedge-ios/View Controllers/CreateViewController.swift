//
//  CreateViewController.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2018 Salt Edge. All rights reserved.
//

import UIKit
import SaltEdge
import PKHUD

class CreateViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createLoginButton: UIButton!
    
    private let fieldsStackView: UIStackView = UIStackView()
    
    private var provider: SEProvider?
    var login: SELogin? {
        didSet {
            if let login = login {
                self.stackView.isHidden = true
                self.requestProvider(with: login.providerCode)
                createLoginButton.setTitle("Reconnect Login", for: .normal)
            } else {
                createLoginButton.setTitle("Connect Login", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.isHidden = true
        stackView.insertArrangedSubview(fieldsStackView, at: 1)
    }
    
    @IBAction func createPressed(_ sender: Any) {
        view.endEditing(true)
        if let login = login {
            reconnectLogin(login)
        } else {
            createLogin()
        }
    }
    
    @IBAction func providersPressed(_ sender: Any) {
        guard let providersVC = ProvidersViewController.create(onPick: { [weak self] provider in
            guard let weakSelf = self else { return }
            
            weakSelf.login = nil
            weakSelf.requestProvider(with: provider.code)
        }) else { return }
        
        let navVC = UINavigationController(rootViewController: providersVC)
        
        present(navVC, animated: true)
    }
    
    private func createLogin() {
        guard let provider = provider else { return }
        
        HUD.show(.labeledProgress(title: "Creating Login", subtitle: nil))
        if provider.isOAuth {
            let params = SECreateOAuthParams(countryCode: provider.countryCode, providerCode: provider.code, returnTo: AppDelegate.applicationURLString, fetchScopes: ["accounts", "transactions"])
            SERequestManager.shared.createOAuthLogin(params: params) { response in
                self.handleOAuthResponse(response)
            }
        } else {
            let params = SELoginParams(countryCode: provider.countryCode, providerCode: provider.code, credentials: gatherCredentials(), fetchScopes: ["accounts", "transactions"])
            SERequestManager.shared.createLogin(with: params, fetchingDelegate: self) { response in
                self.handleLoginResponse(response)
            }
        }
    }
    
    private func reconnectLogin(_ login: SELogin) {
        guard let provider = provider else { return }
        
        HUD.show(.labeledProgress(title: "Reconnecting Login", subtitle: nil))

        if provider.isOAuth {
            let params = SEUpdateOAuthParams(returnTo: AppDelegate.applicationURLString)
            SERequestManager.shared.refreshOAuthLogin(with: login.secret, params: params) { response in
                self.handleOAuthResponse(response)
            }
        } else {
            let params = SELoginReconnectParams(credentials: gatherCredentials())
            SERequestManager.shared.reconnectLogin(with: login.secret, with: params, fetchingDelegate: self) { response in
                self.handleLoginResponse(response)
            }
        }
    }
    
    private func handleLoginResponse(_ response: SEResult<SEResponse<SELogin>>) {
        switch response {
        case .success(let value):
            print(value.data)
        case .failure(let error):
            HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
        }
    }
    
    private func handleOAuthResponse(_ response: SEResult<SEResponse<SEOAuthResponse>>) {
        switch response {
        case .success(let value):
            guard let url = URL(string: value.data.redirectUrl) else { return }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .failure(let error):
            HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
        }
    }
    
    private func requestProvider(with code: String) {
        HUD.show(.labeledProgress(title: "Getting Provider", subtitle: nil))
        SERequestManager.shared.getProvider(code: code) { [weak self] response in
            switch response {
            case .success(let value):
                self?.stackView.isHidden = false
                self?.provider = value.data
                
                guard let requiredFields = value.data.requiredFields else { return }
                
                self?.createRequiredFields(for: requiredFields)
                self?.descriptionLabel.text = value.data.instruction
                HUD.hide(animated: true)
            case .failure(let error):
                HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
                print(error)
            }
        }
    }
    
    private func createRequiredFields(for fields: [SEProviderField]) {
        fieldsStackView.arrangedSubviews.forEach { fieldsStackView.removeArrangedSubview($0) }
        
        fieldsStackView.axis = .vertical
        fieldsStackView.spacing = 20.0
        for field in fields.sorted(by: { $0.position < $1.position }) {
            if let fieldOptions = field.fieldOptions {
                let button = OptionsButton(availableOptions: fieldOptions, fieldName: field.name)
                button.setTitle(field.englishName, for: .normal)
                button.addTarget(self, action: #selector(optionsPressed(_:)), for: .touchUpInside)
                fieldsStackView.addArrangedSubview(button)
            } else {
                let textField = CredentialTextField(placeholder: field.localizedName, fieldName: field.name)
                textField.isSecureTextEntry = field.nature == "password"
                fieldsStackView.addArrangedSubview(textField)
            }
        }
    }
    
    @objc private func optionsPressed(_ sender: OptionsButton) {
        showOptionsActionSheet(options: sender.availableOptions.map({ $0.englishName }), button:  sender)
    }
    
    private func gatherCredentials() -> [String: String] {
        var credentials: [String: String] = [:]
        fieldsStackView.arrangedSubviews.forEach { view in
            if let textField = view as? CredentialTextField, let text = textField.text {
                credentials[textField.fieldName] = text
            } else if let optionsButton = view as? OptionsButton, let choosedOptionName = optionsButton.titleLabel?.text,
                let choosedOption = optionsButton.availableOptions.filter({ $0.englishName == choosedOptionName }).first {
                credentials[optionsButton.fieldName] = choosedOption.name
            }
        }
        return credentials
    }
    
    private func showInteractiveAlertView(title: String, message: String?, fields: [String]?, credentialsBlock: @escaping ([String: String]) -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Send", style: .default, handler: { _ in
            guard let textFields = alertController.textFields else { return }
            
            var credentials: [String: String] = [:]
            for textField in textFields {
                guard let value = textField.text, let fieldName = textField.placeholder else { return }
                
                credentials[fieldName] = value
            }
            credentialsBlock(credentials)
        })
        
        guard let fields = fields else { return }
        
        for field in fields {
            alertController.addTextField { textField in
                textField.placeholder = field
            }
        }
        alertController.addAction(okAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func showOptionsActionSheet(options: [String], button: OptionsButton) {
        let handler: (UIAlertAction) -> Void = { action in
            button.setTitle(action.title, for: .normal)
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for option in options {
            let action = UIAlertAction(title: option, style: .default, handler: handler)
            alertController.addAction(action)
        }
        
        let action = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(action)
        
        present(alertController, animated:  true)
    }

    private func switchToLoginsController() {
        tabBarController?.selectedIndex = 2
    }
}

extension CreateViewController: SELoginFetchingDelegate {
    func failedToFetch(login: SELogin?, message: String) {
        HUD.flash(.labeledError(title: "Error", subtitle: message), delay: 3.0)
    }
    
    func interactiveInputRequested(for login: SELogin) {
        HUD.hide(animated: true)
        showInteractiveAlertView(title: login.providerName,
                                 message: login.lastAttempt.lastStage?.interactiveHtml?.htmlToString,
                                 fields: login.lastAttempt.lastStage?.interactiveFieldsNames) { credentials in
            let params = SELoginInteractiveParams(credentials: credentials)
            HUD.show(.labeledProgress(title: "Checking Credentials", subtitle: nil))
            SERequestManager.shared.confirmLogin(with: login.secret, params: params, fetchingDelegate: self) { response in
                switch response {
                case .success(let value):
                    print(value.data)
                case .failure(let error):
                    HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
                }
            }
        }
    }
    
    func successfullyFinishedFetching(login: SELogin) {
        HUD.hide(animated: true)
        if var logins = UserDefaultsHelper.logins {
            if !logins.contains(login.secret) {
                logins.append(login.secret)
                UserDefaultsHelper.logins = logins
            }
        } else {
            UserDefaultsHelper.logins = [login.secret]
        }
        switchToLoginsController()
    }
}
