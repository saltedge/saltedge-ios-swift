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
    public let extra: SEExtra?
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
        extra = try container.decodeIfPresent(SEExtra.self, forKey: .extra)
        connectionId = try container.decode(String.self, forKey: .connectionId)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}

public struct SEExtra: Decodable {
    public let accountName: String?
    public let status: String?
    public let clientName: String?
    public let iban: String?
    public let swift: String?
    public let cardType: String?
    public let accountNumber: String?
    public let blockedAmount: Double?
    public let availableAmount: Double?
    public let creditLimit: Double?
    public let interestRate: Double?
    public let expiryDate: Date?
    public let openDate: Date?
    public let cards: [String]?
    public let units: Double?
    public let unitPrice: Double?
    public let transactionsCount: TransactionsCount?
    
    enum CodingKeys: String, CodingKey {
        case accountName = "account_name"
        case status
        case clientName = "client_name"
        case iban
        case swift
        case cardType = "card_type" 
        case accountNumber = "account_number"
        case blockedAmount = "blocked_amount" 
        case availableAmount = "available_amount" 
        case creditLimit = "credit_limit"
        case interestRate = "interest_rate" 
        case expiryDate = "expiry_date"
        case openDate = "open_date"
        case cards
        case units
        case unitPrice = "unit_price"
        case transactionsCount = "transactions_count"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accountName = try container.decodeIfPresent(String.self, forKey: .accountName)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        clientName = try container.decodeIfPresent(String.self, forKey: .clientName)
        iban = try container.decodeIfPresent(String.self, forKey: .iban)
        swift = try container.decodeIfPresent(String.self, forKey: .swift)
        cardType = try container.decodeIfPresent(String.self, forKey: .cardType)
        accountNumber = try container.decodeIfPresent(String.self, forKey: .accountName)
        blockedAmount = try container.decodeIfPresent(Double.self, forKey: .blockedAmount)
        availableAmount = try container.decodeIfPresent(Double.self, forKey: .availableAmount)
        creditLimit = try container.decodeIfPresent(Double.self, forKey: .creditLimit)
        interestRate = try container.decodeIfPresent(Double.self, forKey: .interestRate)
        cards = try container.decodeIfPresent([String].self, forKey: .cards)
        units = try container.decodeIfPresent(Double.self, forKey: .units)
        unitPrice = try container.decodeIfPresent(Double.self, forKey: .unitPrice)
        transactionsCount = try container.decodeIfPresent(TransactionsCount.self, forKey: .transactionsCount)
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
