//
//  SETransaction.swift
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

public struct SETransaction: Decodable {
    public let id: String
    public let duplicated: Bool
    public let mode: String
    public let status: String
    public let madeOn: Date
    public let amount: Double
    public let currencyCode: String
    public let description: String
    public let category: String
    public let accountId: String
    public let createdAt: Date
    public let updatedAt: Date
    public let extra: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case duplicated = "duplicated"
        case mode = "mode"
        case status = "status"
        case madeOn = "made_on"
        case amount = "amount"
        case currencyCode = "currency_code"
        case description = "description"
        case category = "category"
        case accountId = "account_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case extra = "extra"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        duplicated = try container.decode(Bool.self, forKey: .duplicated)
        mode = try container.decode(String.self, forKey: .mode)
        status = try container.decode(String.self, forKey: .status)
        amount = try container.decode(Double.self, forKey: .amount)
        currencyCode = try container.decode(String.self, forKey: .currencyCode)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        accountId = try container.decode(String.self, forKey: .accountId)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        extra = try container.decodeIfPresent([String: Any].self, forKey: .extra)
        let dateString = try container.decode(String.self, forKey: .madeOn)
        if let date = DateFormatter.yyyyMMdd.date(from: dateString) {
            madeOn = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .madeOn, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}
