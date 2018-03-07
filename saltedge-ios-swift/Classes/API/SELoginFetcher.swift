//
//  SELoginFetcher.swift
//
//  Copyright (c) 2018 Salt Edge. https://saltedge.com
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

import Foundation

class SELoginFetcher {
    private static let pollingInterval: Double = 3.0

    static func createLogin(with params: SELoginParams, fetchingDelegate: SELoginFetchingDelegate, completion: SEHTTPResponse<SELogin>) {
        HTTPService<SELogin>.makeRequest(LoginRouter.create(params)) { response in
            switch response {
            case .success(let value):
                self.requestPolling(for: value.data, fetchingDelegate: fetchingDelegate)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    static func reconnectLogin(secret: String, params: SELoginReconnectParams, fetchingDelegate: SELoginFetchingDelegate, completion: SEHTTPResponse<SELogin>) {
        HTTPService<SELogin>.makeRequest(LoginRouter.reconnect(params, secret)) { response in
            switch response {
            case .success(let value):
                self.requestPolling(for: value.data, fetchingDelegate: fetchingDelegate)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    static func refreshLogin(secret: String, params: SELoginRefreshParams? = nil, fetchingDelegate: SELoginFetchingDelegate, completion: SEHTTPResponse<SELogin>) {
        HTTPService<SELogin>.makeRequest(LoginRouter.refresh(params, secret)) { response in
            switch response {
            case .success(let value):
                self.requestPolling(for: value.data, fetchingDelegate: fetchingDelegate)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    static func interactiveLogin(with params: SELoginInteractiveParams, secret: String, fetchingDelegate: SELoginFetchingDelegate, completion: SEHTTPResponse<SELogin>) {
        HTTPService<SELogin>.makeRequest(LoginRouter.interactive(params, secret)) { response in
            switch response {
            case .success(let value):
                self.requestPolling(for: value.data, fetchingDelegate: fetchingDelegate)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    static func handleOAuthLogin(loginSecret: String, fetchingDelegate: SELoginFetchingDelegate) {
        self.pollLogin(loginSecret, fetchingDelegate: fetchingDelegate)
    }
    
    private static func requestPolling(for login: SELogin, fetchingDelegate: SELoginFetchingDelegate) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + SELoginFetcher.pollingInterval, execute: {
            self.pollLogin(login.secret, fetchingDelegate: fetchingDelegate)
        })
    }
    
    private static func pollLogin(_ loginSecret: String, fetchingDelegate: SELoginFetchingDelegate) {
        HTTPService<SELogin>.makeRequest(LoginRouter.show(loginSecret)) { response in
            switch response {
            case .success(let value):
                self.handleSuccessPollResponse(for: value.data, fetchingDelegate: fetchingDelegate)
            case .failure(let error):
                fetchingDelegate.failedToFetch(login: nil, message: error.localizedDescription)
            }
        }
    }
    
    private static func handleSuccessPollResponse(for login: SELogin, fetchingDelegate: SELoginFetchingDelegate) {
        switch login.stage {
        case "interactive":
            fetchingDelegate.interactiveInputRequested(for: login)
        case "finish":
            if let message = login.failMessage {
                fetchingDelegate.failedToFetch(login: login, message: message)
            } else {
                fetchingDelegate.successfullyFinishedFetching(login: login)
            }
        default:
            self.requestPolling(for: login, fetchingDelegate: fetchingDelegate)
        }
    }
}
