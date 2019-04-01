//
//  SEConnection.swift
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

public struct SEConnection: Decodable {
    public let id: String
    public let countryCode: String
    public let createdAt: Date
    public let dailyRefresh: Bool
    public let showConsentConfirmation: Bool?
    public let consentTypes: [String]?
    public let consentGivenAt: Date?
    public let lastAttempt: SEAttempt
    public let holderInfo: SEHolderInfo?
    public let lastSuccessAt: Date?
    public let nextRefreshPossibleAt: Date?
    public let providerId: String
    public let providerCode: String
    public let providerName: String
    public let secret: String
    public let status: String
    public let storeCredentials: Bool
    public let updatedAt: Date
    public let customerId: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case countryCode = "country_code"
        case createdAt = "created_at"
        case dailyRefresh = "daily_refresh"
        case showConsentConfirmation = "show_consent_confirmation"
        case consentTypes = "consent_types"
        case consentGivenAt = "consent_given_at"
        case lastAttempt = "last_attempt"
        case holderInfo = "holder_info"
        case lastSuccessAt = "last_success_at"
        case nextRefreshPossibleAt = "next_refresh_possible_at"
        case providerId = "provider_id"
        case providerCode = "provider_code"
        case providerName = "provider_name"
        case secret = "secret"
        case status = "status"
        case storeCredentials = "store_credentials"
        case updatedAt = "updated_at"
        case customerId = "customer_id"
    }
    
    var stage: String {
        if let lastStage = lastAttempt.lastStage {
            return lastStage.name
        }
        
        return "unknown"
    }
    
    var failMessage: String? {
        return lastAttempt.failMessage
    }
}
