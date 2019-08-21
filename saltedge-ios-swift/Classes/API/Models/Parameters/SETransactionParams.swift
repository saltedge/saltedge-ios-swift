//
//  SETransactionParams.swift
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

public struct SETransactionParams: URLEncodable, ParametersEncodable {
    public let accountId: String?
    public let fromId: String?

    public init(accountId: String? = nil, fromId: String? = nil) {
        self.accountId = accountId
        self.fromId = fromId
    }

    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case fromId = "from_id"
    }
}

public struct SERemoveTransactionParams: URLEncodable, ParametersEncodable {
    public let accountId: String
    public let keepDays: Int

    public init(accountId: String, keepDays: Int) {
        self.accountId = accountId
        self.keepDays = keepDays
    }

    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case keepDays = "keep_days"
    }
}

public struct SEDuplicateTransactionsParams: Encodable, ParametersEncodable {
    public let transactionIds: [String]

    public init(ids: [String]) {
        self.transactionIds = ids
    }

    enum CodingKeys: String, CodingKey {
        case transactionIds = "transaction_ids"
    }
}

public struct SEDuplicateTransactionParams: Encodable, ParametersEncodable {
    public let transactionId: String

    public init(id: String) {
        self.transactionId = id
    }

    private enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
    }
}
