//
//  SELoginParams.swift
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

public class SEBaseLoginParams: Encodable, ParametersEncodable {
    let fetchScopes: [String]?
    let fromDate: Date?
    let toDate: Date?
    
    public init(fetchScopes: [String]? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil) {
        self.fetchScopes = fetchScopes
        self.fromDate  = fromDate
        self.toDate    = toDate
    }

    private enum CodingKeys: String, CodingKey {
        case fetchScopes = "fetch_scopes"
        case fromDate  = "from_date"
        case toDate    = "to_date"
    }
    
}

public class SEExtendedLoginParams: SEBaseLoginParams {
    let dailyRefresh: Bool?
    let locale: String?
    let includeFakeProviders: Bool?
    let categorize: Bool?
    let storeCredentials: Bool?
    
    public init(fetchScopes: [String]? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                dailyRefresh: Bool? = nil,
                locale: String? = nil,
                includeFakeProviders: Bool? = nil,
                categorize: Bool? = nil,
                storeCredentials: Bool? = nil) {
        self.dailyRefresh         = dailyRefresh
        self.locale               = locale
        self.includeFakeProviders = includeFakeProviders
        self.categorize           = categorize
        self.storeCredentials     = storeCredentials
        
        super.init(fetchScopes: fetchScopes, fromDate: fromDate, toDate: toDate)
    }
    
    private enum CodingKeys: String, CodingKey {
        case dailyRefresh         = "daily_refresh"
        case locale               = "locale"
        case includeFakeProviders = "include_fake_providers"
        case categorize           = "categorize"
        case storeCredentials     = "store_credentials"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(dailyRefresh, forKey: .dailyRefresh)
        try container.encodeIfPresent(locale, forKey: .locale)
        try container.encodeIfPresent(includeFakeProviders, forKey: .includeFakeProviders)
        try container.encodeIfPresent(categorize, forKey: .categorize)
        try container.encodeIfPresent(storeCredentials, forKey: .storeCredentials)
        
        try super.encode(to: encoder)
    }
}

public class SELoginRefreshParams: SEExtendedLoginParams {
    let excludeAccounts: [Int]?
    
    public init(fetchScopes: [String]? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                dailyRefresh: Bool? = nil,
                locale: String? = nil,
                includeFakeProviders: Bool? = nil,
                categorize: Bool? = nil,
                storeCredentials: Bool? = nil,
                excludeAccounts: [Int]? = nil) {
        self.excludeAccounts = excludeAccounts
        
        super.init(fetchScopes: fetchScopes, fromDate: fromDate, toDate: toDate,
                   dailyRefresh: dailyRefresh, locale: locale, includeFakeProviders: includeFakeProviders,
                   categorize: categorize, storeCredentials: storeCredentials)
    }
    
    private enum CodingKeys: String, CodingKey {
        case exludeAccounts = "exlude_accounts"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(excludeAccounts, forKey: .exludeAccounts)

        try super.encode(to: encoder)
    }
}

public class SELoginReconnectParams: SEExtendedLoginParams {
    let credentials: [String: String]
    
    public init(credentials: [String: String],
                fetchScopes: [String]? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                dailyRefresh: Bool? = nil,
                locale: String? = nil,
                includeFakeProviders: Bool? = nil,
                categorize: Bool? = nil,
                storeCredentials: Bool? = nil) {
        self.credentials = credentials
        
        super.init(fetchScopes: fetchScopes, fromDate: fromDate, toDate: toDate,
                   dailyRefresh: dailyRefresh, locale: locale, includeFakeProviders: includeFakeProviders,
                   categorize: categorize, storeCredentials: storeCredentials)
    }
    
    private enum CodingKeys: String, CodingKey {
        case credentials
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(credentials, forKey: .credentials)
        
        try super.encode(to: encoder)
    }
}

public class SELoginInteractiveParams: SEBaseLoginParams {
    let credentials: [String:  String]
    
    public init(credentials: [String: String],
                fetchScopes: [String]? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil) {
        self.credentials = credentials
        
        super.init(fetchScopes: fetchScopes, fromDate: fromDate, toDate: toDate)
    }
    
    private enum CodingKeys: String, CodingKey {
        case credentials
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(credentials, forKey: .credentials)
        
        try super.encode(to: encoder)
    }
}

public class SELoginParams: SEExtendedLoginParams {
    let countryCode: String
    let providerCode: String
    let credentials: [String: String]
    let fileUrl: String?
    
    public init(countryCode: String,
                providerCode: String,
                credentials: [String: String],
                fetchScopes: [String],
                dailyRefresh: Bool? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                includeFakeProviders: Bool? = nil,
                categorize: Bool? = nil,
                storeCredentials: Bool? = nil,
                fileUrl: String? = nil) {
        self.countryCode  = countryCode
        self.providerCode = providerCode
        self.credentials  = credentials
        self.fileUrl      = fileUrl
        
        super.init(fetchScopes: fetchScopes, fromDate: fromDate, toDate: toDate,
                   dailyRefresh: dailyRefresh, locale: locale, includeFakeProviders: includeFakeProviders,
                   categorize: categorize, storeCredentials: storeCredentials)
    }
    
    private enum CodingKeys: String, CodingKey {
        case countryCode          = "country_code"
        case providerCode         = "provider_code"
        case credentials          = "credentials"
        case fileUrl              = "file_url"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(providerCode, forKey: .providerCode)
        try container.encode(credentials, forKey: .credentials)
        try container.encodeIfPresent(fileUrl, forKey: .fileUrl)

        try super.encode(to: encoder)
    }
}
