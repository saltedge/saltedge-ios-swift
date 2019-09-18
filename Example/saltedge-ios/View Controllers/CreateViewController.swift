//
//  CreateViewController.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import UIKit
import SaltEdge
import PKHUD

class CreateViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createConnectionButton: UIButton!
    
    private let fieldsStackView: UIStackView = UIStackView()
    
    private var provider: SEProvider?
    var connection: SEConnection? {
        didSet {
            if let connection = connection {
                self.stackView.isHidden = true
                self.requestProvider(with: connection.providerCode)
                createConnectionButton.setTitle("Reconnect Connection", for: .normal)
            } else {
                createConnectionButton.setTitle("Connect Connection", for: .normal)
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
        if let connection = connection {
            reconnect(connection)
        } else {
            createConnection()
        }
    }
    
    @IBAction func providersPressed(_ sender: Any) {
        guard let providersVC = ProvidersViewController.create(onPick: { [weak self] provider in
            guard let weakSelf = self else { return }
            
            weakSelf.connection = nil
            weakSelf.requestProvider(with: provider.code)
        }) else { return }
        
        let navVC = UINavigationController(rootViewController: providersVC)
        
        present(navVC, animated: true)
    }
    
    private func createConnection() {
        guard let provider = provider else { return }
        
        HUD.show(.labeledProgress(title: "Creating Connection", subtitle: nil))
        if provider.isOAuth {
            let params = SECreateOAuthParams(
                consent: SEConsent(scopes: ["account_details", "transactions_details"]),
                countryCode: provider.countryCode,
                providerCode: provider.code,
                attempt: SEAttempt(returnTo: AppDelegate.applicationURLString)
            )
            SERequestManager.shared.createOAuthConnection(params: params) { response in
                self.handleOAuthResponse(response)
            }
        } else {
            let params = SEConnectionParams(
                consent: SEConsent(scopes: ["account_details", "transactions_details"]),
                countryCode: provider.countryCode,
                providerCode: provider.code,
                credentials: gatherCredentials()
            )
            SERequestManager.shared.createConnection(with: params, fetchingDelegate: self) { response in
                self.handleConnectionResponse(response)
            }
        }
    }
    
    private func reconnect(_ connection: SEConnection) {
        guard let provider = provider else { return }
        
        HUD.show(.labeledProgress(title: "Reconnecting Connection", subtitle: nil))

        if provider.isOAuth {
            let params = SEConnectionRefreshParams(attempt: SEAttempt(returnTo: AppDelegate.applicationURLString))

            SERequestManager.shared.refreshConnection(with: connection.secret, params: params, fetchingDelegate: self) { response in
                switch response {
                case .success(let value):
                    // Nothing here. Need to wait for SEconnectionFetchingDelegate callbacks
                    print(value.data)
                case .failure(let error):
                    HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
                }
            }
        } else {
            let params = SEConnectionReconnectParams(
                consent: SEConsent(scopes: ["account_details", "transactions_details"]),
                credentials: gatherCredentials()
            )

            SERequestManager.shared.reconnectConnection(with: connection.secret, with: params, fetchingDelegate: self) { response in
                self.handleConnectionResponse(response)
            }
        }
    }
    
    private func handleConnectionResponse(_ response: SEResult<SEResponse<SEConnection>>) {
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

    private func switchToConnectionsController() {
        tabBarController?.selectedIndex = 2
    }
}

extension CreateViewController: SEConnectionFetchingDelegate {
    func failedToFetch(connection: SEConnection?, message: String) {
        HUD.flash(.labeledError(title: "Error", subtitle: message), delay: 3.0)
    }
    
    func interactiveInputRequested(for connection: SEConnection) {
        HUD.hide(animated: true)
        showInteractiveAlertView(title: connection.providerName,
                                 message: connection.lastAttempt.lastStage?.interactiveHtml?.htmlToString,
                                 fields: connection.lastAttempt.lastStage?.interactiveFieldsNames) { credentials in
            let params = SEConnectionInteractiveParams(credentials: credentials)
            HUD.show(.labeledProgress(title: "Checking Credentials", subtitle: nil))
            SERequestManager.shared.confirmConnection(with: connection.secret, params: params, fetchingDelegate: self) { response in
                switch response {
                case .success(let value):
                    print(value.data)
                case .failure(let error):
                    HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
                }
            }
        }
    }
    
    func successfullyFinishedFetching(connection: SEConnection) {
        HUD.hide(animated: true)
        if var connections = UserDefaultsHelper.connectionSecrets {
            if !connections.contains(connection.secret) {
                connections.append(connection.secret)
                UserDefaultsHelper.connectionSecrets = connections
            }
        } else {
            UserDefaultsHelper.connectionSecrets = [connection.secret]
        }
        switchToConnectionsController()
    }
}
