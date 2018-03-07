//
//  SETokenParams.swift
//
//  Copyright (c) 2018 Salt Edge. https://saltedge.com
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

public class SEBaseTokenParams: Encodable, ParametersEncodable {
    let fetchScopes: [String]?
    let customFields: String?
    let dailyRefresh: Bool?
    let fromDate: Date?
    let toDate: Date?
    let locale: String?
    let returnTo: String?
    let returnLoginId: Bool?
    let providerModes: [String]?
    let categorize: Bool?
    let javascriptCallbackType: String?
    let includeFakeProviders: Bool?
    let lostConnectionNotify: Bool?
    let showConsentConfirmation: Bool?

    init(fetchScopes: [String]? = nil,
         customFields: String? = nil,
         dailyRefresh: Bool? = nil,
         fromDate: Date? = nil,
         toDate: Date? = nil,
         locale: String? = nil,
         returnTo: String? = nil,
         returnLoginId: Bool? = nil,
         providerModes: [String]? = nil,
         categorize: Bool? = nil,
         javascriptCallbackType: String? = nil,
         includeFakeProviders: Bool? = nil,
         lostConnectionNotify: Bool? = nil,
         showConsentConfirmation: Bool? = nil) {
        self.fetchScopes = fetchScopes
        self.customFields = customFields
        self.dailyRefresh = dailyRefresh
        self.fromDate = fromDate
        self.toDate = toDate
        self.locale = locale
        self.returnTo = returnTo
        self.returnLoginId = returnLoginId
        self.providerModes = providerModes
        self.categorize = categorize
        self.javascriptCallbackType = javascriptCallbackType
        self.includeFakeProviders = includeFakeProviders
        self.lostConnectionNotify = lostConnectionNotify
        self.showConsentConfirmation = showConsentConfirmation
    }
    
    private enum CodingKeys: String, CodingKey {
        case fetchScopes = "fetch_scopes"
        case customFields = "custom_fields"
        case dailyRefresh = "daily_refresh"
        case fromDate = "from_date"
        case toDate = "to_date"
        case locale = "locale"
        case returnTo = "return_to"
        case returnLoginId = "return_login_id"
        case providerModes = "provider_modes"
        case categorize = "categorize"
        case javascriptCallbackType = "javascript_callback_type"
        case includeFakeProviders = "include_fake_providers"
        case lostConnectionNotify = "lost_connection_notify"
        case showConsentConfirmation = "show_consent_confirmation"
    }
}

public class SECreateTokenParams: SEBaseTokenParams {
    let allowedCountries: [String]?
    let providerCode: String?
    let credentialsStrategy: String?

    public init(allowedCountries: [String]? = nil,
                fetchScopes: [String],
                providerCode: String? = nil,
                customFields: String? = nil,
                dailyRefresh: Bool? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnTo: String? = nil,
                returnLoginId: Bool? = nil,
                providerModes: [String]? = nil,
                categorize: Bool? = nil,
                javascriptCallbackType: String? = nil,
                includeFakeProviders: Bool? = nil,
                lostConnectionNotify: Bool? = nil,
                showConsentConfirmation: Bool? = nil,
                credentialsStrategy: String? = nil) {
        self.allowedCountries = allowedCountries
        self.providerCode = providerCode
        self.credentialsStrategy = credentialsStrategy

        super.init(fetchScopes: fetchScopes,
                   customFields: customFields,
                   dailyRefresh: dailyRefresh,
                   fromDate: fromDate,
                   toDate: toDate,
                   locale: locale,
                   returnTo: returnTo,
                   returnLoginId: returnLoginId,
                   providerModes: providerModes,
                   categorize: categorize,
                   javascriptCallbackType: javascriptCallbackType,
                   includeFakeProviders: includeFakeProviders,
                   lostConnectionNotify: lostConnectionNotify,
                   showConsentConfirmation: showConsentConfirmation)
    }
    
    private enum CodingKeys: String, CodingKey {
        case allowedCountries = "allowed_countries"
        case providerCode = "provider_code"
        case credentialsStrategy = "credentials_strategy"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(allowedCountries, forKey: .allowedCountries)
        try container.encodeIfPresent(providerCode, forKey: .providerCode)
        try container.encodeIfPresent(credentialsStrategy, forKey: .credentialsStrategy)
        
        try super.encode(to: encoder)
    }
}

public class SERefreshTokenParams: SEBaseTokenParams {
    let excludeAccounts: [Int]?
    
    public init(excludeAccounts: [Int]? = nil,
                fetchScopes: [String]? = nil,
                customFields: String? = nil,
                dailyRefresh: Bool? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnTo: String? = nil,
                returnLoginId: Bool? = nil,
                providerModes: [String]? = nil,
                categorize: Bool? = nil,
                javascriptCallbackType: String? = nil,
                includeFakeProviders: Bool? = nil,
                lostConnectionNotify: Bool? = nil,
                showConsentConfirmation: Bool? = nil) {
        self.excludeAccounts = excludeAccounts

        super.init(fetchScopes: fetchScopes,
                   customFields: customFields,
                   dailyRefresh: dailyRefresh,
                   fromDate: fromDate,
                   toDate: toDate,
                   locale: locale,
                   returnTo: returnTo,
                   returnLoginId: returnLoginId,
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

public class SEReconnectTokenParams: SEBaseTokenParams {
    let excludeAccounts: [Int]?
    let credentialsStrategy: String?
    
    public init(excludeAccounts: [Int]? = nil,
                fetchScopes: [String]? = nil,
                customFields: String? = nil,
                dailyRefresh: Bool? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnTo: String? = nil,
                returnLoginId: Bool? = nil,
                providerModes: [String]? = nil,
                categorize: Bool? = nil,
                javascriptCallbackType: String? = nil,
                includeFakeProviders: Bool? = nil,
                lostConnectionNotify: Bool? = nil,
                showConsentConfirmation: Bool? = nil,
                credentialsStrategy: String? = nil) {
        self.excludeAccounts = excludeAccounts
        self.credentialsStrategy = credentialsStrategy
        
        super.init(fetchScopes: fetchScopes,
                   customFields: customFields,
                   dailyRefresh: dailyRefresh,
                   fromDate: fromDate,
                   toDate: toDate,
                   locale: locale,
                   returnTo: returnTo,
                   returnLoginId: returnLoginId,
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
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(excludeAccounts, forKey: .excludeAccounts)
        try container.encodeIfPresent(credentialsStrategy, forKey: .credentialsStrategy)
        
        try super.encode(to: encoder)
    }
}
