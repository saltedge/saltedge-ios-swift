//
//  SEProvider.swift
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

public struct SEProvider: Decodable {
    public let id: String
    public let code: String
    public let name: String
    public let mode: String
    public let status: String
    public let automaticFetch: Bool
    public let customerNotifiedOnSignIn: Bool
    public let interactive: Bool
    public let identificationMode: String
    public let instruction: String
    public let homeURL: String
    public let loginURL: String
    public let logoURL: String
    public let countryCode: String
    public let refreshTimeout: Int
    public let holderInfo: [String]
    public let maxConsentDays: Int?
    public let timezone: String
    public let maxInteractiveDelay: Int
    public let optionalInteractivity: Bool
    public let regulated: Bool
    public let maxFetchInterval: Int
    public let supportedFetchScopes: [String]
    public let supportedAccountExtraFields: [String]
    public let supportedTransactionExtraFields: [String]
    public let supportedAccountNatures: [String]
    public let supportedAccountTypes: [String]
    public let identificationCodes: [String]
    public let bicCodes: [String]
    public let supportedIframeEmbedding: Bool
    public let createdAt: String
    public let updatedAt: String
    public let requiredFields: [SEProviderField]?
    
    public var isOAuth: Bool {
        return mode == "oauth"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case code = "code"
        case name = "name"
        case mode = "mode"
        case status = "status"
        case automaticFetch = "automatic_fetch"
        case customerNotifiedOnSignIn = "customer_notified_on_sign_in"
        case interactive = "interactive"
        case identificationMode = "identification_mode"
        case instruction = "instruction"
        case homeURL = "home_url"
        case loginURL = "login_url"
        case logoURL = "logo_url"
        case countryCode = "country_code"
        case refreshTimeout = "refresh_timeout"
        case holderInfo = "holder_info"
        case maxConsentDays = "max_consent_days"
        case timezone = "timezone"
        case maxInteractiveDelay = "max_interactive_delay"
        case optionalInteractivity = "optional_interactivity"
        case regulated = "regulated"
        case maxFetchInterval = "max_fetch_interval"
        case supportedFetchScopes = "supported_fetch_scopes"
        case supportedAccountExtraFields = "supported_account_extra_fields"
        case supportedTransactionExtraFields = "supported_transaction_extra_fields"
        case supportedAccountNatures = "supported_account_natures"
        case supportedAccountTypes = "supported_account_types"
        case identificationCodes = "identification_codes"
        case bicCodes = "bic_codes"
        case supportedIframeEmbedding = "supported_iframe_embedding"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case requiredFields = "required_fields"
    }
}

public struct SEProviderField: Decodable {
    public let nature: String
    public let name: String
    public let englishName: String
    public let localizedName: String
    public let purpleOptional: Bool
    public let position: Int
    public let fieldOptions: [SEProviderFieldOption]?
    
    enum CodingKeys: String, CodingKey {
        case nature = "nature"
        case name = "name"
        case englishName = "english_name"
        case localizedName = "localized_name"
        case purpleOptional = "optional"
        case position = "position"
        case fieldOptions = "field_options"
    }
}

public struct SEProviderFieldOption: Decodable {
    public let name: String
    public let englishName: String
    public let localizedName: String
    public let optionValue: String
    public let selected: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case englishName = "english_name"
        case localizedName = "localized_name"
        case optionValue = "option_value"
        case selected = "selected"
    }
}

