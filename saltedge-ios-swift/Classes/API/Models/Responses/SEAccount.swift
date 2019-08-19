//
//  Account.swift
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

public struct SEAccount: Decodable {
    public let id: String
    public let name: String
    public let nature: String
    public let balance: Double
    public let currencyCode: String
    public let extra: SEAccountExtra?
    public let connectionId: String
    public let createdAt: Date
    public let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case nature = "nature"
        case balance = "balance"
        case currencyCode = "currency_code"
        case extra = "extra"
        case connectionId = "connection_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        nature = try container.decode(String.self, forKey: .nature)
        balance = try container.decode(Double.self, forKey: .balance)
        currencyCode = try container.decode(String.self, forKey: .currencyCode)
        extra = try container.decodeIfPresent(SEAccountExtra.self, forKey: .extra)
        connectionId = try container.decode(String.self, forKey: .connectionId)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}

public struct SEAccountExtra: Decodable {
    public let accountName: String?
    public let accountNumber: String?
    public let assets: [String]?
    public let availableAmount: Double?
    public let blockedAmount: Double?
    public let cards: [String]?
    public let cardType: String?
    public let clientName: String?
    public let creditLimit: Double?
    public let expiryDate: Date?
    public let iban: String?
    public let interestRate: Double?
    public let openDate: Date?
    public let status: String?
    public let swift: String?
    public let transactionsCount: TransactionsCount?
    public let unitPrice: Double?
    public let units: Double?
    
    enum CodingKeys: String, CodingKey {
        case accountName = "account_name"
        case accountNumber = "account_number"
        case assets = "assets"
        case availableAmount = "available_amount"
        case blockedAmount = "blocked_amount"
        case cards = "cards"
        case cardType = "card_type"
        case clientName = "client_name"
        case creditLimit = "credit_limit"
        case expiryDate = "expiry_date"
        case iban = "iban"
        case interestRate = "interest_rate"
        case openDate = "open_date"
        case status = "status"
        case swift = "swift"
        case transactionsCount = "transactions_count"
        case units = "units"
        case unitPrice = "unit_price"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accountName = try container.decodeIfPresent(String.self, forKey: .accountName)
        accountNumber = try container.decodeIfPresent(String.self, forKey: .accountName)
        assets = try container.decodeIfPresent([String].self, forKey: .assets)
        availableAmount = try container.decodeIfPresent(Double.self, forKey: .availableAmount)
        blockedAmount = try container.decodeIfPresent(Double.self, forKey: .blockedAmount)
        cards = try container.decodeIfPresent([String].self, forKey: .cards)
        cardType = try container.decodeIfPresent(String.self, forKey: .cardType)
        clientName = try container.decodeIfPresent(String.self, forKey: .clientName)
        creditLimit = try container.decodeIfPresent(Double.self, forKey: .creditLimit)
        iban = try container.decodeIfPresent(String.self, forKey: .iban)
        interestRate = try container.decodeIfPresent(Double.self, forKey: .interestRate)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        swift = try container.decodeIfPresent(String.self, forKey: .swift)
        transactionsCount = try container.decodeIfPresent(TransactionsCount.self, forKey: .transactionsCount)
        units = try container.decodeIfPresent(Double.self, forKey: .units)
        unitPrice = try container.decodeIfPresent(Double.self, forKey: .unitPrice)
        if let expiryDateString = try container.decodeIfPresent(String.self, forKey: .expiryDate),
            let expiryDate = DateFormatter.yyyyMMdd.date(from: expiryDateString) {
            self.expiryDate = expiryDate
        } else {
            self.expiryDate = nil
        }
        if let openDateString = try container.decodeIfPresent(String.self, forKey: .openDate),
            let openDate = DateFormatter.yyyyMMdd.date(from: openDateString) {
            self.openDate = openDate
        } else {
            self.openDate = nil
        }
    }
}

public struct TransactionsCount: Decodable {
    public let posted: Int
    public let pending: Int
    
    enum CodingKeys: String, CodingKey {
        case posted = "posted"
        case pending = "pending"
    }
}
