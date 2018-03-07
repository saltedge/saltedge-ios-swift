//
//  ConnectViewController.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2018 Salt Edge. All rights reserved.
//

import UIKit
import SaltEdge
import WebKit
import PKHUD

final class ConnectViewController: UIViewController {
    private var provider: SEProvider?
    
    @IBOutlet weak var webView: SEWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.isHidden = true
        webView.stateDelegate = self
    }
    
    @IBAction func providersPressed(_ sender: Any) {
        guard let providersVC = ProvidersViewController.create(onPick: { [weak self] provider in
            guard let weakSelf = self else { return }
            
            weakSelf.provider = provider
            weakSelf.requestToken()
        }) else { return }
        
        let navVC = UINavigationController(rootViewController: providersVC)
        
        present(navVC, animated: true)
    }
    
    func requestToken(login: SELogin? = nil, refresh: Bool = false) {
        HUD.show(.labeledProgress(title: "Requesting Token", subtitle: nil))
        if let login = login {
            if refresh {
                // Set javascriptCallbackType to "iframe" to receive callback with login_id and login_secret
                // see https://docs.saltedge.com/guides/connect
                let params = SERefreshTokenParams(returnTo: "http://httpbin.org", javascriptCallbackType: "iframe")
                SERequestManager.shared.refreshToken(with: login.secret, params: params) { [weak self] response in
                    self?.handleTokenResponse(response)
                }
            } else {
                // Set javascriptCallbackType to "iframe" to receive callback with login_id and login_secret
                // see https://docs.saltedge.com/guides/connect
                let params = SEReconnectTokenParams(returnTo: "http://httpbin.org", javascriptCallbackType: "iframe")
                SERequestManager.shared.reconnectToken(with: login.secret, params: params) { [weak self] response in
                    self?.handleTokenResponse(response)
                }
            }
        } else {
            guard let provider = provider else { return }
            
            // Set javascriptCallbackType to "iframe" to receive callback with login_id and login_secret
            // see https://docs.saltedge.com/guides/connect
            let tokenParams = SECreateTokenParams(fetchScopes: ["accounts", "transactions"], providerCode: provider.code, returnTo: "http://httpbin.org", javascriptCallbackType: "iframe")
            // Check if SERequestManager will call handleTokenResponse
            SERequestManager.shared.createToken(params: tokenParams) { [weak self] response in
                self?.handleTokenResponse(response)
            }
        }
    }
    
    private func handleTokenResponse(_ response: SEResult<SEResponse<SETokenResponse>>) {
        switch response {
        case .success(let value):
            HUD.hide(animated: true)
            if let url = URL(string: value.data.connectUrl) {
                let request = URLRequest(url: url)
                webView.load(request)
                webView.isHidden = false
            }
        case .failure(let error):
            HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
        }
    }

    private func switchToLoginsController() {
        tabBarController?.selectedIndex = 2
    }
}

extension ConnectViewController: SEWebViewDelegate {
    func webView(_ webView: SEWebView, didReceiveCallbackWithResponse response: SEConnectResponse) {
        switch response.stage {
        case .success:
            switchToLoginsController()
        case .fetching:
            guard let loginSecret = response.secret else { return }
            
            if var logins = UserDefaultsHelper.logins {
                if !logins.contains(loginSecret) {
                    logins.append(loginSecret)
                    UserDefaultsHelper.logins = logins
                }
            } else {
                UserDefaultsHelper.logins = [loginSecret]
            }
        case .error:
            HUD.flash(.labeledError(title: "Cannot Fetch Login", subtitle: nil), delay: 3.0)
        }
    }
    
    func webView(_ webView: SEWebView, didReceiveCallbackWithError error: Error) {
        HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
    }
}


