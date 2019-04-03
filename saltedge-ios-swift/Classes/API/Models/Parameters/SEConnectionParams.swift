//
//  SEConnectionParams.swift
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

public class SEBaseConnectionParams: Encodable, ParametersEncodable {
    public let fromDate: Date?
    public let toDate: Date?
    
    public init(fromDate: Date? = nil,
                toDate: Date? = nil) {
        self.fromDate  = fromDate
        self.toDate    = toDate
    }

    private enum CodingKeys: String, CodingKey {
        case fromDate = "from_date"
        case toDate   = "to_date"
    }
}

public class SEExtendedConnectionParams: SEBaseConnectionParams {
    public let dailyRefresh: Bool?
    public let locale: String?
    public let includeFakeProviders: Bool?
    public let categorize: Bool?
    public let storeCredentials: Bool?
    
    public init(fromDate: Date? = nil,
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
        
        super.init(fromDate: fromDate, toDate: toDate)
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

public class SEConnectionRefreshParams: SEExtendedConnectionParams {
    public let attempt: SEAttempt?
    public let categorization: String?

    public init(attempt: SEAttempt? = nil,
                categorization: String? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                dailyRefresh: Bool? = nil,
                locale: String? = nil,
                includeFakeProviders: Bool? = nil,
                categorize: Bool? = nil,
                storeCredentials: Bool? = nil) {
        self.attempt = attempt
        self.categorization = categorization

        super.init(fromDate: fromDate, toDate: toDate, dailyRefresh: dailyRefresh,
                   locale: locale, includeFakeProviders: includeFakeProviders,
                   categorize: categorize, storeCredentials: storeCredentials)
    }

    private enum CodingKeys: String, CodingKey {
        case attempt = "attempt"
        case dailyRefresh = "daily_refresh"
        case categorization = "categorziation"
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(attempt, forKey: .attempt)
        try container.encodeIfPresent(categorization, forKey: .categorization)

        try super.encode(to: encoder)
    }
}

public class SEConnectionUpdateStatusParams: SEExtendedConnectionParams {
    public let status: String?

    public init(fromDate: Date? = nil,
                toDate: Date? = nil,
                dailyRefresh: Bool? = nil,
                locale: String? = nil,
                includeFakeProviders: Bool? = nil,
                categorize: Bool? = nil,
                storeCredentials: Bool? = nil,
                status: String? = nil) {
        self.status = status

        super.init(fromDate: fromDate, toDate: toDate, dailyRefresh: dailyRefresh,
                   locale: locale, includeFakeProviders: includeFakeProviders,
                   categorize: categorize, storeCredentials: storeCredentials)
    }

    private enum CodingKeys: String, CodingKey {
        case status = "status"
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
        
        try super.encode(to: encoder)
    }
}

public class SEConnectionReconnectParams: SEExtendedConnectionParams {
    public let consent: SEConsent
    public let credentials: [String: String]
    
    public init(consent: SEConsent,
                credentials: [String: String],
                fromDate: Date? = nil,
                toDate: Date? = nil,
                dailyRefresh: Bool? = nil,
                locale: String? = nil,
                includeFakeProviders: Bool? = nil,
                categorize: Bool? = nil,
                storeCredentials: Bool? = nil) {
        self.consent = consent
        self.credentials = credentials
        
        super.init(fromDate: fromDate, toDate: toDate, dailyRefresh: dailyRefresh,
                   locale: locale, includeFakeProviders: includeFakeProviders,
                   categorize: categorize, storeCredentials: storeCredentials)
    }
    
    private enum CodingKeys: String, CodingKey {
        case credentials
        case consent
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(consent, forKey: .consent)
        try container.encodeIfPresent(credentials, forKey: .credentials)
        
        try super.encode(to: encoder)
    }
}

public class SEConnectionInteractiveParams: SEBaseConnectionParams {
    public let credentials: [String:  String]
    
    public init(credentials: [String: String],
                fromDate: Date? = nil,
                toDate: Date? = nil) {
        self.credentials = credentials
        
        super.init(fromDate: fromDate, toDate: toDate)
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

public class SEConnectionParams: SEExtendedConnectionParams {
    public let consent: SEConsent
    public let countryCode: String
    public let providerCode: String
    public let credentials: [String: String]
    public let fileUrl: String?
    
    public init(consent: SEConsent,
                countryCode: String,
                providerCode: String,
                credentials: [String: String],
                dailyRefresh: Bool? = nil,
                fromDate: Date? = nil,
                toDate: Date? = nil,
                locale: String? = nil,
                includeFakeProviders: Bool? = nil,
                categorize: Bool? = nil,
                storeCredentials: Bool? = nil,
                fileUrl: String? = nil) {
        self.consent      = consent
        self.countryCode  = countryCode
        self.providerCode = providerCode
        self.credentials  = credentials
        self.fileUrl      = fileUrl
        
        super.init(fromDate: fromDate, toDate: toDate, dailyRefresh: dailyRefresh,
                   locale: locale, includeFakeProviders: includeFakeProviders,
                   categorize: categorize, storeCredentials: storeCredentials)
    }
    
    private enum CodingKeys: String, CodingKey {
        case consent      = "consent"
        case countryCode  = "country_code"
        case providerCode = "provider_code"
        case credentials  = "credentials"
        case fileUrl      = "file_url"
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(providerCode, forKey: .providerCode)
        try container.encode(credentials, forKey: .credentials)
        try container.encode(consent, forKey: .consent)
        try container.encodeIfPresent(fileUrl, forKey: .fileUrl)

        try super.encode(to: encoder)
    }
}
