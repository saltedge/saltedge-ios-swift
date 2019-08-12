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
    private lazy var attempt = SEAttempt(returnTo: "http://httpbin.org/")
    private lazy var consent = SEConsent(scopes: ["account_details", "transactions_details"])
    
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
            if refresh {
                // Set javascriptCallbackType to "iframe" to receive callback with connection_id and connection_secret
                // see https://docs.saltedge.com/guides/connect
                let params = SERefreshSessionsParams(
                    attempt: attempt,
                    javascriptCallbackType: "iframe"
                )
                SERequestManager.shared.refreshSession(with: connection.secret, params: params) { [weak self] response in
                    self?.handleConnectSessionResponse(response)
                }
            } else {
                // Set javascriptCallbackType to "iframe" to receive callback with connection_id and connection_secret
                // see https://docs.saltedge.com/guides/connect
                let params = SEReconnectSessionsParams(
                    attempt: attempt,
                    javascriptCallbackType: "iframe",
                    consent: consent
                )
                SERequestManager.shared.reconnectSession(with: connection.secret, params: params) { [weak self] response in
                    self?.handleConnectSessionResponse(response)
                }
            }
        } else {
            createSession()
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

    private func handleLeadSessionResponse(_ response: SEResult<SEResponse<SELeadSessionResponse>>) {
        switch response {
        case .success(let value):
            HUD.hide(animated: true)
            if let url = URL(string: value.data.redirectUrl) {
                let request = URLRequest(url: url)
                webView.load(request)
                webView.isHidden = false
            }
        case .failure(let error):
            HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
        }
    }


    private func switchToConnectionsController() {
        tabBarController?.selectedIndex = SERequestManager.shared.isPartner ? 1 : 2
    }

    private func createSession() {
        guard let provider = provider else { return }

        if SERequestManager.shared.isPartner {
            let leadSessionParams = SELeadSessionParams(
                consent: consent,
                providerCode: provider.code,
                attempt: attempt,
                javascriptCallbackType: "iframe"
            )

            // Check if SERequestManager will call handleConnectSessionResponse
            SERequestManager.shared.createLeadSession(params: leadSessionParams) { [weak self] response in
                self?.handleLeadSessionResponse(response)
            }
        } else {
            let connectSessionsParams = SEConnectSessionsParams(
                attempt: attempt,
                providerCode: provider.code,
                javascriptCallbackType: "iframe",
                consent: consent
            )

            // Check if SERequestManager will call handleConnectSessionResponse
            SERequestManager.shared.createConnectSession(params: connectSessionsParams) { [weak self] response in
                self?.handleConnectSessionResponse(response)
            }
        }
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

    func webView(_ webView: SEWebView, didHandleRequestUrl url: URL) {
        if url.absoluteString == attempt.returnTo {
            webView.isHidden = true
        }
    }
}
