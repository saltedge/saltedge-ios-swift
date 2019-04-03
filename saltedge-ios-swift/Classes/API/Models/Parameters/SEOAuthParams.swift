//
//  SEOAuthParams.swift
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

public class SEBasicOAuthParams: Encodable, ParametersEncodable {
    public let returnTo: String
    public let dailyRefresh: Bool?
    public let customFields: String?
    public let fromDate: Date?
    public let toDate: Date?
    public let locale: String?
    public let returnConnectionId: Bool?
    public let categorize: Bool?
    public let includeFakeProvider: Bool?
    
    public init(returnTo: String,
                dailyRefresh: Bool? = nil,
                customFields: String? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnConnectionId: Bool? = nil,
                categorize: Bool? = nil,
                includeFakeProvider: Bool? = nil) {
        self.returnTo = returnTo
        self.dailyRefresh = dailyRefresh
        self.customFields = customFields
        self.fromDate = fromDate
        self.toDate = toDate
        self.locale = locale
        self.returnConnectionId = returnConnectionId
        self.categorize = categorize
        self.includeFakeProvider = includeFakeProvider
    }
    
    private enum CodingKeys: String, CodingKey {
        case returnTo = "return_to"
        case dailyRefresh = "daily_refresh"
        case customFields = "custom_fields"
        case fromDate = "from_date"
        case toDate = "to_date"
        case locale
        case returnConnectionId = "return_connection_id"
        case categorize
        case includeFakeProvider = "include_fake_provider"
    }
}

public class SECreateOAuthParams: SEBasicOAuthParams {
    let consent: SEConsent
    public let countryCode: String
    public let providerCode: String
    public let attempt: SEAttempt?
    
    public init(consent: SEConsent,
                countryCode: String,
                providerCode: String,
                attempt: SEAttempt? = nil,
                returnTo: String,
                dailyRefresh: Bool? = nil,
                customFields: String? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnConnectionId: Bool? = nil,
                categorize: Bool? = nil,
                includeFakeProvider: Bool? = nil) {
        self.consent = consent
        self.providerCode = providerCode
        self.countryCode = countryCode
        self.attempt = attempt
        
        super.init(returnTo: returnTo,
                   dailyRefresh: dailyRefresh,
                   customFields: customFields,
                   fromDate: fromDate,
                   toDate: toDate,
                   locale: locale,
                   returnConnectionId: returnConnectionId,
                   categorize: categorize,
                   includeFakeProvider: includeFakeProvider)
    }
    
    private enum CodingKeys: String, CodingKey {
        case consent
        case attempt
        case countryCode = "country_code"
        case providerCode = "provider_code"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(consent, forKey: .consent)
        try container.encodeIfPresent(attempt, forKey: .attempt)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(providerCode, forKey: .providerCode)

        try super.encode(to: encoder)
    }
}

public class SEReconnectOAuthParams: SEBasicOAuthParams {
    public let consent: SEConsent
    public let attempt: SEAttempt?
    public let excludeAccounts: [Int]?
    
    public init(consent: SEConsent,
                returnTo: String,
                attempt: SEAttempt? = nil,
                dailyRefresh: Bool? = nil,
                customFields: String? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnConnectionId: Bool? = nil,
                categorize: Bool? = nil,
                includeFakeProvider: Bool? = nil,
                excludeAccounts: [Int]? = nil) {
        self.consent = consent
        self.attempt = attempt
        self.excludeAccounts = excludeAccounts
        
        super.init(returnTo: returnTo,
                   dailyRefresh: dailyRefresh,
                   customFields: customFields,
                   fromDate: fromDate,
                   toDate: toDate,
                   locale: locale,
                   returnConnectionId: returnConnectionId,
                   categorize: categorize,
                   includeFakeProvider: includeFakeProvider)
    }
    
    private enum CodingKeys: String, CodingKey {
        case consent
        case attempt
        case excludeAccounts = "exclude_accounts"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(consent, forKey: .consent)
        try container.encodeIfPresent(attempt, forKey: .attempt)
        try container.encodeIfPresent(excludeAccounts, forKey: .excludeAccounts)

        try super.encode(to: encoder)
    }
}
