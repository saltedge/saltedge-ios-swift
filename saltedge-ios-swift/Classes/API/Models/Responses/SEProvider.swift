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
    public let instruction: String
    public let homeURL: String
    public let loginURL: String
    public let countryCode: String
    public let refreshTimeout: Int
    public let holderInfo: [String]
    public let createdAt: String
    public let updatedAt: String
    public let requiredFields: [SEProviderField]?
    public let logoURL: URL
    
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
        case instruction = "instruction"
        case homeURL = "home_url"
        case loginURL = "login_url"
        case countryCode = "country_code"
        case refreshTimeout = "refresh_timeout"
        case holderInfo = "holder_info"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case requiredFields = "required_fields"
        case logoURL = "logo_url"
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

