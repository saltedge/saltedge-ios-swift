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
    case duplicate(ConnectionSecret, SEDuplicateTransactionsParams)
    case duplicates(ConnectionSecret, SETransactionParams?)
    case unduplicate(ConnectionSecret, SEDuplicateTransactionsParams)
    case remove(ConnectionSecret, SERemoveTransactionParams)

    var method: HTTPMethod {
        switch self {
        case .list, .pending, .duplicates: return .get
        case .duplicate, .unduplicate: return .put
        case .remove: return .delete
        }
    }
    
    var query: String {
        switch self {
        case .list, .remove: return "transactions"
        case .pending: return "transactions/pending"
        case .duplicate: return "transactions/duplicate"
        case .duplicates: return "transactions/duplicates"
        case .unduplicate: return "transactions/unduplicate"
        }
    }

    var headers: Headers {
        switch self {
        case .list(let secret, _), .pending(let secret, _), .duplicate(let secret, _),
             .duplicates(let secret, _), .unduplicate(let secret, _), .remove(let secret, _): return SEHeaders.cached.with(connectionSecret: secret)
        }
    }

    var parameters: ParametersEncodable? {
        switch self {
        case .list(_, let params), .pending(_, let params), .duplicates(_, let params): return params
        case .duplicate(_, let params), .unduplicate(_, let params): return params
        case .remove(_, let params): return params
        }
    }
}
