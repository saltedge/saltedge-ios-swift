//
//  ConnectSessionsRouter.swift
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

import Foundation

enum ConnectSessionsRouter: Routable {
    case create(SECreateSessionsParams)
    case reconnect(ConnectionSecret, SEReconnectSessionsParams)
    case refresh(ConnectionSecret, SERefreshSessionsParams)
    
    var method: HTTPMethod {
        return .post
    }
    
    var url: URL {
        switch self {
        case .create: return APIEndpoints.baseURL.appendingPathComponent("connect_sessions/create")
        case .reconnect: return APIEndpoints.baseURL.appendingPathComponent("connect_sessions/reconnect")
        case .refresh: return APIEndpoints.baseURL.appendingPathComponent("connect_sessions/refresh")
        }
    }
    
    var headers: Headers {
        switch self {
        case .create: return SEHeaders.cached.sessionHeaders
        case .reconnect(let secret, _), .refresh(let secret, _): return SEHeaders.cached.with(connectionSecret: secret)
        }
    }
    
    var parameters: ParametersEncodable? {
        switch self {
        case .create(let params): return params
        case .reconnect(_, let params): return params
        case .refresh(_, let params): return params
        }
    }
}
