//
//  SEConnectSessionsParams.swift
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

public class SEBaseConnectSessionsParams: Encodable, ParametersEncodable {
    public let customFields: String?
    public let dailyRefresh: Bool?
    public let fromDate: Date?
    public let toDate: Date?
    public let locale: String?
    public let returnConnectionId: Bool?
    public let providerModes: [String]?
    public let categorize: Bool?
    public let javascriptCallbackType: String?
    public let includeFakeProviders: Bool?
    public let lostConnectionNotify: Bool?
    public let showConsentConfirmation: Bool?
    public let attempt: SEAttempt?

    init(attempt: SEAttempt? = nil,
         customFields: String? = nil,
         dailyRefresh: Bool? = nil,
         fromDate: Date? = nil,
         toDate: Date? = nil,
         locale: String? = nil,
         returnConnectionId: Bool? = nil,
         providerModes: [String]? = nil,
         categorize: Bool? = nil,
         javascriptCallbackType: String? = nil,
         includeFakeProviders: Bool? = nil,
         lostConnectionNotify: Bool? = nil,
         showConsentConfirmation: Bool? = nil) {
        self.attempt = attempt
        self.customFields = customFields
        self.dailyRefresh = dailyRefresh
        self.fromDate = fromDate
        self.toDate = toDate
        self.locale = locale
        self.returnConnectionId = returnConnectionId
        self.providerModes = providerModes
        self.categorize = categorize
        self.javascriptCallbackType = javascriptCallbackType
        self.includeFakeProviders = includeFakeProviders
        self.lostConnectionNotify = lostConnectionNotify
        self.showConsentConfirmation = showConsentConfirmation
    }
    
    private enum CodingKeys: String, CodingKey {
        case attempt = "attempt"
        case customFields = "custom_fields"
        case dailyRefresh = "daily_refresh"
        case fromDate = "from_date"
        case toDate = "to_date"
        case locale = "locale"
        case returnConnectionId = "return_connection_id"
        case providerModes = "provider_modes"
        case categorize = "categorize"
        case javascriptCallbackType = "javascript_callback_type"
        case includeFakeProviders = "include_fake_providers"
        case lostConnectionNotify = "lost_connection_notify"
        case showConsentConfirmation = "show_consent_confirmation"
    }
}

public class SECreateSessionsParams: SEBaseConnectSessionsParams {
    public let allowedCountries: [String]?
    public let consent: SEConsent
    public let credentialsStrategy: String?
    public let providerCode: String?

    public init(allowedCountries: [String]? = nil,
                attempt: SEAttempt? = nil,
                providerCode: String? = nil,
                customFields: String? = nil,
                dailyRefresh: Bool? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnConnectionId: Bool? = nil,
                providerModes: [String]? = nil,
                categorize: Bool? = nil,
                javascriptCallbackType: String? = nil,
                includeFakeProviders: Bool? = nil,
                lostConnectionNotify: Bool? = nil,
                showConsentConfirmation: Bool? = nil,
                credentialsStrategy: String? = nil,
                consent: SEConsent) {
        self.allowedCountries = allowedCountries
        self.providerCode = providerCode
        self.credentialsStrategy = credentialsStrategy
        self.consent = consent

        super.init(attempt: attempt,
                   customFields: customFields,
                   dailyRefresh: dailyRefresh,
                   fromDate: fromDate,
                   toDate: toDate,
                   locale: locale,
                   returnConnectionId: returnConnectionId,
                   providerModes: providerModes,
                   categorize: categorize,
                   javascriptCallbackType: javascriptCallbackType,
                   includeFakeProviders: includeFakeProviders,
                   lostConnectionNotify: lostConnectionNotify,
                   showConsentConfirmation: showConsentConfirmation)
    }
    
    private enum CodingKeys: String, CodingKey {
        case consent = "consent"
        case allowedCountries = "allowed_countries"
        case providerCode = "provider_code"
        case credentialsStrategy = "credentials_strategy"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(allowedCountries, forKey: .allowedCountries)
        try container.encodeIfPresent(providerCode, forKey: .providerCode)
        try container.encodeIfPresent(credentialsStrategy, forKey: .credentialsStrategy)
        try container.encode(consent, forKey: .consent)
        
        try super.encode(to: encoder)
    }
}

public class SERefreshSessionsParams: SEBaseConnectSessionsParams {
    public let excludeAccounts: [Int]?
    
    public init(excludeAccounts: [Int]? = nil,
                attempt: SEAttempt? = nil,
                customFields: String? = nil,
                dailyRefresh: Bool? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnConnectionId: Bool? = nil,
                providerModes: [String]? = nil,
                categorize: Bool? = nil,
                javascriptCallbackType: String? = nil,
                includeFakeProviders: Bool? = nil,
                lostConnectionNotify: Bool? = nil,
                showConsentConfirmation: Bool? = nil) {
        self.excludeAccounts = excludeAccounts

        super.init(attempt: attempt,
                   customFields: customFields,
                   dailyRefresh: dailyRefresh,
                   fromDate: fromDate,
                   toDate: toDate,
                   locale: locale,
                   returnConnectionId: returnConnectionId,
                   providerModes: providerModes,
                   categorize: categorize,
                   javascriptCallbackType: javascriptCallbackType,
                   includeFakeProviders: includeFakeProviders,
                   lostConnectionNotify: lostConnectionNotify,
                   showConsentConfirmation: showConsentConfirmation)
    }
    
    private enum CodingKeys: String, CodingKey {
        case excludeAccounts = "exclude_accounts"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(excludeAccounts, forKey: .excludeAccounts)

        try super.encode(to: encoder)
    }

}

public class SEReconnectSessionsParams: SEBaseConnectSessionsParams {
    public let excludeAccounts: [Int]?
    public let credentialsStrategy: String?
    public let consent: SEConsent
    
    public init(excludeAccounts: [Int]? = nil,
                attempt: SEAttempt? = nil,
                customFields: String? = nil,
                dailyRefresh: Bool? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnConnectionId: Bool? = nil,
                providerModes: [String]? = nil,
                categorize: Bool? = nil,
                javascriptCallbackType: String? = nil,
                includeFakeProviders: Bool? = nil,
                lostConnectionNotify: Bool? = nil,
                showConsentConfirmation: Bool? = nil,
                credentialsStrategy: String? = nil,
                consent: SEConsent) {
        self.excludeAccounts = excludeAccounts
        self.credentialsStrategy = credentialsStrategy
        self.consent = consent
        
        super.init(attempt: attempt,
                   customFields: customFields,
                   dailyRefresh: dailyRefresh,
                   fromDate: fromDate,
                   toDate: toDate,
                   locale: locale,
                   returnConnectionId: returnConnectionId,
                   providerModes: providerModes,
                   categorize: categorize,
                   javascriptCallbackType: javascriptCallbackType,
                   includeFakeProviders: includeFakeProviders,
                   lostConnectionNotify: lostConnectionNotify,
                   showConsentConfirmation: showConsentConfirmation)
    }
    
    private enum CodingKeys: String, CodingKey {
        case excludeAccounts = "exclude_accounts"
        case credentialsStrategy = "credentials_strategy"
        case consent = "consent"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(excludeAccounts, forKey: .excludeAccounts)
        try container.encodeIfPresent(credentialsStrategy, forKey: .credentialsStrategy)
        try container.encode(consent, forKey: .consent)
        
        try super.encode(to: encoder)
    }
}
