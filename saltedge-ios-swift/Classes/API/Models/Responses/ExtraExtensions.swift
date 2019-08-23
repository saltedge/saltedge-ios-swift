//
//  ExtraExtensions.swift
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

extension Dictionary where Key == String {
    
    // MARK: Common extra:

    public var accountNumber: String? {
        get {
            return self["account_number"] as? String
        }
    }

    public var closingBalance: Double? {
        get {
            return self["closing_balance"] as? Double
        }
    }

    public var unitPrice: Double? {
        get {
            return self["unit_price"] as? Double
        }
    }

    public var units: Double? {
        get {
            return self["units"] as? Double
        }
    }

    public var openingBalance: Double? {
        get {
            return self["opening_balance"] as? Double
        }
    }
    
    // MARK: - SEAccount extra fields:

    public var accountName: String? {
        get {
            return self["account_name"] as? String
        }
    }
    
    public var assets: [[String: Any]]? {
        get {
            return self["assets"] as? [[String: Any]]
        }
    }
    
    public var availableAmount: Double? {
        get {
            return self["available_amount"] as? Double
        }
    }
    
    public var blockedAmount: Double? {
        get {
            return self["blocked_amount"] as? Double
        }
    }

    public var cardType: String? {
        get {
            return self["card_type"] as? String
        }
    }

    public var cards: [String]? {
        get {
            return self["cards"] as? [String]
        }
    }

    public var currentDate: Date? {
        get {
            if let dateString = self["current_date"] as? String,
                let date = DateFormatter.yyyyMMdd.date(from: dateString) {
                return date
            }
            return nil
        }
    }

    public var currentTime: Date? {
        get {
            if let dateString = self["current_time"] as? String,
                let date = DateFormatter.time.date(from: dateString) {
                return date
            }
            return nil
        }
    }

    public var clientName: String? {
        get {
            return self["client_name"] as? String
        }
    }
    
    public var creditLimit: Double? {
        get {
            return self["credit_limit"] as? Double
        }
    }
    
    public var expiryDate: Date? {
        get {
            if let dateString = self["expiry_date"] as? String,
                let date = DateFormatter.yyyyMMdd.date(from: dateString) {
                return date
            }
            return nil
        }
    }
    
    public var iban: String? {
        get {
            return self["iban"] as? String
        }
    }
    
    public var interestRate: Double? {
        get {
            return self["interest_rate"] as? Double
        }
    }
    
    public var nextPaymentAmount: Double? {
        get {
            return self["next_payment_amount"] as? Double
        }
    }

    public var nextPaymentDate: Date? {
        get {
            if let dateString = self["next_payment_date"] as? String,
                let date = DateFormatter.yyyyMMdd.date(from: dateString) {
                return date
            }
            return nil
        }
    }

    public var openDate: Date? {
        get {
            if let dateString = self["open_date"] as? String,
                let date = DateFormatter.yyyyMMdd.date(from: dateString) {
                return date
            }
            return nil
        }
    }

    public var partial: Bool? {
        get {
            return self["partial"] as? Bool
        }
    }

    public var sortCode: String? {
        get {
            return self["sort_code"] as? String
        }
    }

    public var statementCutDate: Date? {
        get {
            if let dateString = self["statement_cut_date"] as? String,
                let date = DateFormatter.yyyyMMdd.date(from: dateString) {
                return date
            }
            return nil
        }
    }
    
    public var status: String? {
        get {
            return self["status"] as? String
        }
    }
    
    public var swift: String? {
        get {
            return self["swift"] as? String
        }
    }

    public var totalPaymentAmount: Double? {
        get {
            return self["total_payment_amount"] as? Double
        }
    }
    
    public var transactionsCount: TransactionsCount? {
        get {
            if let dict = self["transactions_count"] as? [String: Any],
                let posted = dict["posted"] as? Int,
                let pending = dict["pending"] as? Int {
                return TransactionsCount(posted: posted, pending: pending)
            }
            return nil
        }
    }

    // MARK: - SETransaction extra fields:

    public var accountBalanceSnapshot: Double? {
        get {
            return self["account_balance_snapshot"] as? Double
        }
    }
    
    public var additional: String? {
        get {
            return self["additional"] as? String
        }
    }
    
    public var assetAmount: Double? {
        get {
            return self["asset_amount"] as? Double
        }
    }
    
    public var assetCode: String? {
        get {
            return self["asset_code"] as? String
        }
    }
    
    public var checkNumber: String? {
        get {
            return self["check_number"] as? String
        }
    }
    
    public var constantCode: String? {
        get {
            return self["constant_code"] as? String
        }
    }
    
    public var convert: Bool? {
        get {
            return self["convert"] as? Bool
        }
    }
    
    public var categorizationConfidence: Double? {
        get {
            return self["categorization_confidence"] as? Double
        }
    }
    
    public var customerCategoryCode: String? {
        get {
            return self["customer_category_code"] as? String
        }
    }
    
    public var customerCategoryName: String? {
        get {
            return self["customer_category_name"] as? String
        }
    }
    
    public var id: String? {
        get {
            return self["id"] as? String
        }
    }
    
    public var information: String? {
        get {
            return self["information"] as? String
        }
    }
    
    public var mcc: String? {
        get {
            return self["mcc"] as? String
        }
    }
    
    public var merchantId: String? {
        get {
            return self["merchant_id"] as? String
        }
    }
    
    public var originalAmount: Double? {
        get {
            return self["original_amount"] as? Double
        }
    }
    
    public var originalCategory: String? {
        get {
            return self["original_category"] as? String
        }
    }
    
    public var originalCurrencyCode: String? {
        get {
            return self["original_currency_code"] as? String
        }
    }
    
    public var originalSubcategory: String? {
        get {
            return self["original_subcategory"] as? String
        }
    }
    
    public var payee: String? {
        get {
            return self["payee"] as? String
        }
    }
    
    public var payeeInformation: String? {
        get {
            return self["payee_information"] as? String
        }
    }
    
    public var payer: String? {
        get {
            return self["payer"] as? String
        }
    }
    
    public var payerInformation: String? {
        get {
            return self["payer_information"] as? String
        }
    }
    
    public var possibleDuplicate: Bool? {
        get {
            return self["possible_duplicate"] as? Bool
        }
    }
    
    public var postingDate: Date? {
        get {
            if let dateString = self["posting_date"] as? String,
                let date = DateFormatter.yyyyMMdd.date(from: dateString) {
                return date
            }
            return nil
        }
    }
    
    public var postingTime: String? {
        get {
            return self["posting_time"] as? String
        }
    }
    
    public var recordNumber: String? {
        get {
            return self["record_number"] as? String
        }
    }
    
    public var specificCode: String? {
        get {
            return self["specific_code"] as? String
        }
    }
    
    public var tags: [String]? {
        get {
            return self["tags"] as? [String]
        }
    }
    
    public var time: Date? {
        get {
            if let dateString = self["time"] as? String,
                let date = DateFormatter.time.date(from: dateString) {
                return date
            }
            return nil
        }
    }
    
    public var transferAccountName: String? {
        get {
            return self["transfer_account_name"] as? String
        }
    }
    
    public var type: String? {
        get {
            return self["type"] as? String
        }
    }
    
    public var variableCode: String? {
        get {
            return self["variable_code"] as? String
        }
    }
}
