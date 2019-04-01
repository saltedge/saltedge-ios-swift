//
//  TransactionRouter.swift
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

enum TransactionRouter: Routable {
    case list(ConnectionSecret, SETransactionParams?)
    case pending(ConnectionSecret, SETransactionParams?)
    case duplicate(SEDuplicateTransactionsParams)
    case duplicates(SETransactionParams?)
    case unduplicate(SEDuplicateTransactionsParams)

    var method: HTTPMethod {
        switch self {
        case .list, .pending, .duplicates: return .get
        case .duplicate, .unduplicate: return .put
        }
    }
    
    var url: URL {
        switch self {
        case .list: return APIEndpoints.baseURL.appendingPathComponent("transactions")
        case .pending: return APIEndpoints.baseURL.appendingPathComponent("transactions/pending")
        case .duplicate: return APIEndpoints.baseURL.appendingPathComponent("transactions/duplicate")
        case .duplicates: return APIEndpoints.baseURL.appendingPathComponent("transactions/duplicates")
        case .unduplicate: return APIEndpoints.baseURL.appendingPathComponent("transactions/unduplicate")
        }
    }
    
    var headers: Headers {
        switch self {
        case .list(let secret, _), .pending(let secret, _): return SEHeaders.cached.with(connectionSecret: secret)
        case .duplicate, .duplicates, .unduplicate: return SEHeaders.cached.sessionHeaders
        }
    }
    
    var parameters: ParametersEncodable? {
        switch self {
        case .list(_, let params), .pending(_, let params), .duplicates(let params): return params
        case .duplicate(let params), .unduplicate(let params): return params
        }
    }
}
