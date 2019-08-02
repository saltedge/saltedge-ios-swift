//
//  SELeadSessionParams.swift
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

public struct SELeadSessionParams: Encodable, ParametersEncodable {
    public let consent: SEConsent
    public let attempt: SEAttempt
    public let customerId: String?
    public let allowedCountries: [String]?
    public let providerCode: String?
    public let skipProviderSelect: Bool?
    public let dailyRefresh: Bool?
    public let disableProvidersSearch: Bool?
    public let returnConnectionSearch: Bool?
    public let providerModes: [String]?
    public let categorization: String?
    public let javascriptCallbackType: String?
    public let includeFakeProviders: Bool?
    public let lostConnectionNotify: Bool?
    public let showConsentConfirmation: Bool?
    public let credentialsStrategy: String?

    public init(consent: SEConsent,
         attempt: SEAttempt,
         customerId: String? = nil,
         allowedCountries: [String]? = nil,
         providerCode: String? = nil,
         skipProviderSelect: Bool? = nil,
         dailyRefresh: Bool? = nil,
         disableProvidersSearch: Bool? = nil,
         returnConnectionSearch: Bool? = nil,
         providerModes: [String]? = nil,
         categorization: String? = nil,
         javascriptCallbackType: String? = nil,
         includeFakeProviders: Bool? = nil,
         lostConnectionNotify: Bool? = nil,
         showConsentConfirmation: Bool? = nil,
         credentialsStrategy: String? = nil) {
        self.consent = consent
        self.attempt = attempt
        self.customerId = customerId
        self.allowedCountries = allowedCountries
        self.providerCode = providerCode
        self.skipProviderSelect = skipProviderSelect
        self.dailyRefresh = dailyRefresh
        self.disableProvidersSearch = disableProvidersSearch
        self.returnConnectionSearch = returnConnectionSearch
        self.providerModes = providerModes
        self.categorization = categorization
        self.javascriptCallbackType = javascriptCallbackType
        self.includeFakeProviders = includeFakeProviders
        self.lostConnectionNotify = lostConnectionNotify
        self.showConsentConfirmation = showConsentConfirmation
        self.credentialsStrategy = credentialsStrategy
    }

    private enum CodingKeys: String, CodingKey {
        case consent = "consent"
        case attempt = "attempt"
        case customerId = "customer_id"
        case allowedCountries = "allowed_countries"
        case providerCode = "provider_code"
        case skipProviderSelect = "skip_provider_select"
        case dailyRefresh = "daily_refresh"
        case disableProvidersSearch = "disable_providers_search"
        case returnConnectionSearch = "return_connection_search"
        case providerModes = "provider_modes"
        case categorization = "categorization"
        case javascriptCallbackType = "javascript_callback_type"
        case includeFakeProviders = "include_fake_providers"
        case lostConnectionNotify = "lost_connection_notify"
        case showConsentConfirmation = "show_consent_confirmation"
        case credentialsStrategy = "credentials_strategy"
    }
}
