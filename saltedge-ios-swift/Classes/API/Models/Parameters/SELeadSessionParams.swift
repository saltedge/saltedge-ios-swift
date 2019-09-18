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

public class SELeadSessionParams: SEConnectSessionsParams {
    public let categorization: String?
    public let returnConnectionSearch: Bool?
    public let skipProviderSelect: Bool?

    public init(consent: SEConsent,
                allowedCountries: [String]? = nil,
                credentialsStrategy: String? = nil,
                providerCode: String? = nil,
                categorization: String? = nil,
                returnConnectionSearch: Bool? = nil,
                disableProvidersSearch: Bool? = nil,
                skipProviderSelect: Bool? = nil,
                attempt: SEAttempt? = nil,
                customFields: String? = nil,
                dailyRefresh: Bool? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                returnConnectionId: Bool? = nil,
                providerModes: [String]? = nil,
                categorize: Bool? = nil,
                javascriptCallbackType: String? = nil,
                includeFakeProviders: Bool? = nil,
                lostConnectionNotify: Bool? = nil,
                showConsentConfirmation: Bool? = nil) {
        self.categorization = categorization
        self.returnConnectionSearch = returnConnectionSearch
        self.skipProviderSelect = skipProviderSelect

        super.init(attempt: attempt,
                   customFields: customFields,
                   dailyRefresh: dailyRefresh,
                   fromDate: fromDate,
                   toDate: toDate,
                   returnConnectionId: returnConnectionId,
                   providerModes: providerModes,
                   categorize: categorize,
                   javascriptCallbackType: javascriptCallbackType,
                   includeFakeProviders: includeFakeProviders,
                   lostConnectionNotify: lostConnectionNotify,
                   showConsentConfirmation: showConsentConfirmation,
                   consent: consent)
    }

    private enum CodingKeys: String, CodingKey {
        case categorization = "categorization"
        case returnConnectionSearch = "return_connection_search"
        case disableProvidersSearch = "disable_providers_search"
        case skipProviderSelect = "skip_provider_select"
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(categorization, forKey: .categorization)
        try container.encodeIfPresent(returnConnectionSearch, forKey: .returnConnectionSearch)
        try container.encodeIfPresent(skipProviderSelect, forKey: .skipProviderSelect)

        try super.encode(to: encoder)
    }
}
