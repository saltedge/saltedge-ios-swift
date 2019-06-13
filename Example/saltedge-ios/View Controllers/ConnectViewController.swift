//
//  ConnectViewController.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
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
    
    func requestToken(connection: SEConnection? = nil, refresh: Bool = false) {
        HUD.show(.labeledProgress(title: "Requesting Token", subtitle: nil))
        if let connection = connection {
            let consent = SEConsent(scopes: ["account_details", "transactions_details"])
            if refresh {
                // Set javascriptCallbackType to "iframe" to receive callback with connection_id and connection_secret
                // see https://docs.saltedge.com/guides/connect
                let params = SERefreshSessionsParams(
                    attempt: SEAttempt(returnTo: "http://httpbin.org"),
                    javascriptCallbackType: "iframe"
                )
                SERequestManager.shared.refreshSession(with: connection.secret, params: params) { [weak self] response in
                    self?.handleConnectSessionResponse(response)
                }
            } else {
                // Set javascriptCallbackType to "iframe" to receive callback with connection_id and connection_secret
                // see https://docs.saltedge.com/guides/connect
                let params = SEReconnectSessionsParams(
                    attempt: SEAttempt(returnTo: "http://httpbin.org"),
                    javascriptCallbackType: "iframe",
                    consent: consent
                )
                SERequestManager.shared.reconnectSession(with: connection.secret, params: params) { [weak self] response in
                    self?.handleConnectSessionResponse(response)
                }
            }
        } else {
            guard let provider = provider else { return }
            
            // Set javascriptCallbackType to "iframe" to receive callback with connection_id and connection_secret
            // see https://docs.saltedge.com/guides/connect
            let languageCode = Locale.preferredLanguageCode.lowercased()
            let connectSessionsParams = SECreateSessionsParams(
                attempt: SEAttempt(locale: languageCode, returnTo: "http://httpbin.org"),
                providerCode: provider.code,
                javascriptCallbackType: "iframe",
                consent: SEConsent(scopes: ["account_details", "transactions_details"])
            )
            // Check if SERequestManager will call handleConnectSessionResponse
            SERequestManager.shared.createConnectSession(params: connectSessionsParams) { [weak self] response in
                self?.handleConnectSessionResponse(response)
            }
        }
    }
    
    private func handleConnectSessionResponse(_ response: SEResult<SEResponse<SEConnectSessionResponse>>) {
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

    private func switchToConnectionsController() {
        tabBarController?.selectedIndex = 2
    }
}

extension ConnectViewController: SEWebViewDelegate {
    func webView(_ webView: SEWebView, didReceiveCallbackWithResponse response: SEConnectResponse) {
        switch response.stage {
        case .success:
            switchToConnectionsController()
        case .fetching:
            guard let connectionSecret = response.secret else { return }
            
            if var connections = UserDefaultsHelper.connections {
                if !connections.contains(connectionSecret) {
                    connections.append(connectionSecret)
                    UserDefaultsHelper.connections = connections
                }
            } else {
                UserDefaultsHelper.connections = [connectionSecret]
            }
        case .error:
            HUD.flash(.labeledError(title: "Cannot Fetch Connection", subtitle: nil), delay: 3.0)
        }
    }
    
    func webView(_ webView: SEWebView, didReceiveCallbackWithError error: Error) {
        HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
    }
}
