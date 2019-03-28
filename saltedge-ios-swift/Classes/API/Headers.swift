//
//  Headers.swift
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

/* HTTP Headers */
struct HeaderKeys {
    static let accept = "Accept"
    static let contentType = "Content-Type"
    static let secret = "Secret"
    static let appId = "App-id"
    static let customerSecret = "Customer-secret"
    static let connectionSecret = "Connection-secret"
}

typealias Headers = [String: String]

class SEHeaders {
    static let cached = SEHeaders()
    private init() { self.sessionHeaders = SEHeaders.requestHeaders }
    
    var sessionHeaders: Headers

    static var requestHeaders: Headers {
        return [ HeaderKeys.accept: "application/json",
                 HeaderKeys.contentType: "application/json" ]
    }
    
    func set(appId: String, appSecret: String) {
        sessionHeaders = sessionHeaders.mergeWith([ HeaderKeys.appId: appId,
                                                    HeaderKeys.secret: appSecret ])
    }
    
   func set(customerSecret: String) {
        sessionHeaders = sessionHeaders.mergeWith([ HeaderKeys.customerSecret: customerSecret ])
    }
    
    func with(connectionSecret: String) -> Headers {
        return sessionHeaders.mergeWith([ HeaderKeys.connectionSecret: connectionSecret ])
    }
}
