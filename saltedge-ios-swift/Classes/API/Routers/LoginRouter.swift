//
//  LoginRouter.swift
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

typealias LoginSecret = String
enum LoginRouter: Routable {
    case create(SELoginParams)
    case show(LoginSecret)
    case reconnect(SELoginReconnectParams, LoginSecret)
    case interactive(SELoginInteractiveParams, LoginSecret)
    case refresh(SELoginRefreshParams?, LoginSecret)
    case remove(LoginSecret)
    case inactivate(LoginSecret)
    case destroyCredentials(LoginSecret)
    
    var method: HTTPMethod {
        switch self {
        case .show: return .get
        case .create: return .post
        case .reconnect, .interactive, .refresh, .inactivate, .destroyCredentials: return .put
        case .remove: return .delete
        }
    }
    
    var url: URL {
        switch self {
        case .show, .create, .remove:
            return APIEndpoints.baseURL.appendingPathComponent("login")
        case .reconnect:
            return APIEndpoints.baseURL.appendingPathComponent("login/reconnect")
        case .interactive:
            return APIEndpoints.baseURL.appendingPathComponent("login/interactive")
        case .refresh:
            return APIEndpoints.baseURL.appendingPathComponent("login/refresh")
        case .inactivate:
            return APIEndpoints.baseURL.appendingPathComponent("login/inactivate")
        case .destroyCredentials:
            return APIEndpoints.baseURL.appendingPathComponent("login/destroy_credentials")
            
        }
    }
    
    var headers: Headers {
        switch self {
        case .create:
            return SEHeaders.cached.sessionHeaders
        case .show(let secret),
             .reconnect(_, let secret),
             .interactive(_, let secret),
             .refresh(_, let secret),
             .remove(let secret),
             .inactivate(let secret),
             .destroyCredentials(let secret):
            return SEHeaders.cached.with(loginSecret: secret)
        }
    }
    
    var parameters: ParametersEncodable? {
        switch self {
        case .create(let params): return params
        case .reconnect(let params, _): return params
        case .refresh(let params, _): return params
        case .interactive(let params, _): return params
        default: return nil
        }
    }
}
