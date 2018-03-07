//
//  SEOAuthParams.swift
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

public class SEBasicOAuthParams: Encodable, ParametersEncodable {
    let returnTo: String
    let dailyRefresh: Bool?
    let fetchScopes: [String]?
    let customFields: String?
    let fromDate: Date?
    let toDate: Date?
    let locale: String?
    let returnLoginId: Bool?
    let categorize: Bool?
    let includeFakeProvider: Bool?
    
    public init(returnTo: String,
                dailyRefresh: Bool? = nil,
                fetchScopes: [String]? = nil,
                customFields: String? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnLoginId: Bool? = nil,
                categorize: Bool? = nil,
                includeFakeProvider: Bool? = nil) {
        self.returnTo = returnTo
        self.dailyRefresh = dailyRefresh
        self.fetchScopes = fetchScopes
        self.customFields = customFields
        self.fromDate = fromDate
        self.toDate = toDate
        self.locale = locale
        self.returnLoginId = returnLoginId
        self.categorize = categorize
        self.includeFakeProvider = includeFakeProvider
    }
    
    private enum CodingKeys: String, CodingKey {
        case returnTo = "return_to"
        case dailyRefresh = "daily_refresh"
        case fetchScopes = "fetch_scopes"
        case customFields = "custom_fields"
        case fromDate = "from_date"
        case toDate = "to_date"
        case locale
        case returnLoginId = "return_login_id"
        case categorize
        case includeFakeProvider = "include_fake_provider"
    }
}

public class SECreateOAuthParams: SEBasicOAuthParams {
    public let countryCode: String
    public let providerCode: String
    
    public init(countryCode: String,
                providerCode: String,
                returnTo: String,
                fetchScopes: [String],
                dailyRefresh: Bool? = nil,
                customFields: String? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnLoginId: Bool? = nil,
                categorize: Bool? = nil,
                includeFakeProvider: Bool? = nil) {
        self.providerCode = providerCode
        self.countryCode = countryCode
        
        super.init(returnTo: returnTo,
                   dailyRefresh: dailyRefresh,
                   fetchScopes: fetchScopes,
                   customFields: customFields,
                   fromDate: fromDate,
                   toDate: toDate,
                   locale: locale,
                   returnLoginId: returnLoginId,
                   categorize: categorize,
                   includeFakeProvider: includeFakeProvider)
    }
    
    private enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case providerCode = "provider_code"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(providerCode, forKey: .providerCode)

        try super.encode(to: encoder)
    }
}

public class SEUpdateOAuthParams: SEBasicOAuthParams {
    let excludeAccounts: [Int]?
    
    public init(returnTo: String,
                dailyRefresh: Bool? = nil,
                fetchScopes: [String]? = nil,
                customFields: String? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                returnLoginId: Bool? = nil,
                categorize: Bool? = nil,
                includeFakeProvider: Bool? = nil,
                excludeAccounts: [Int]? = nil) {
        self.excludeAccounts = excludeAccounts
        
        super.init(returnTo: returnTo,
                   dailyRefresh: dailyRefresh,
                   fetchScopes: fetchScopes,
                   customFields: customFields,
                   fromDate: fromDate,
                   toDate: toDate,
                   locale: locale,
                   returnLoginId: returnLoginId,
                   categorize: categorize,
                   includeFakeProvider: includeFakeProvider)
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
