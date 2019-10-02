//
//  SEWebView.swift
//
//  Copyright (c) 2019 Salt Edge. https://saltedge.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import WebKit

/**
 The callback scheme of the Salt Edge Connect protocol.
 */
let seCallbackScheme: String = "saltbridge"

/**
 The callback host of the Salt Edge Connect protocol.
 */
let seCallbackHost: String = "connect"

/**
 SEWebView is a subclass of UIWebView designed for assisting with Salt Edge Connect implementation in iOS apps.
 
 [See for more infromation](https://docs.saltedge.com/guides/connect/)
 */
open class SEWebView: WKWebView {
    /**
     The state delegate of the connection that is currently processed. This object will be notified about events such as the state of the connection **(fetching, success, error)** and about any errors that will occur in the processing.
     
     - warning: must not be nil in order to receive Salt Edge Connect callbacks.
     */
    public weak var stateDelegate: SEWebViewDelegate?
    
    public init(frame: CGRect) {
        super.init(frame: frame, configuration: WKWebViewConfiguration())
        navigationDelegate = self
        uiDelegate = self
        #if os(iOS)
            tintColor = .black
        #endif
        allowsBackForwardNavigationGestures = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationDelegate = self
        uiDelegate = self
        #if os(iOS)
            tintColor = .black
        #endif
        allowsBackForwardNavigationGestures = true
    }

    private func handleBackForwardWebView(navigationAction: WKNavigationAction, urlRequest: URLRequest) {
        if navigationAction.navigationType == .backForward {
            load(urlRequest)
        }
    }
}

extension SEWebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { decisionHandler(.allow); return }

        handleBackForwardWebView(navigationAction: navigationAction, urlRequest: navigationAction.request)

        if url.isCallback {
            let (response, error) = url.callbackParameters
            if let data = response, error == nil {
                self.stateDelegate?.webView(self, didReceiveCallbackWithResponse: data)
            } else if let error = error {
                self.stateDelegate?.webView(self, didReceiveCallbackWithError: error)
            }

            decisionHandler(.cancel)
        } else {
            self.stateDelegate?.webView(self, didHandleRequestUrl: url)
            decisionHandler(.allow)
        }
    }
}

extension SEWebView: WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let targetFrame = navigationAction.targetFrame else {
            webView.load(navigationAction.request)
            return nil
        }

        if !targetFrame.isMainFrame {
            webView.load(navigationAction.request)
        }
        return self
    }
}
