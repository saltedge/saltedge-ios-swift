//
//  SEAttempt.swift
//
//  Copyright (c) 2020 Salt Edge. https://saltedge.com
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

public struct SEAttempt: Codable {
    public let id: String?
    public let fetchScopes: [String]?
    public let apiMode: String?
    public let apiVersion: String?
    public let automaticFetch: Bool?
    public let dailyRefresh: Bool?
    public let categorize: Bool?
    public let createdAt: Date?
    public let customFields: [String: String]?
    public let deviceType: String?
    public let remoteIp: String?
    public let excludeAccounts: [Int]?
    public let failAt: Date?
    public let failErrorClass: String?
    public let failMessage: String?
    public let finished: Bool?
    public let finishedRecent: Bool?
    public let interactive: Bool?
    public let locale: String?
    public let partial: Bool?
    public let storeCredentials: Bool?
    public let successAt: Date?
    public let updatedAt: Date?
    public let showConsentConfirmation: Bool?
    public let consentTypes: [String]?
    public let consentGivenAt: Date?
    public let lastStage: SEStage?
    public let stages: [SEStage]?
    public let returnTo: String?
    public let fromDate: Date?
    public let toDate: Date?

    public init(
        id: String? = nil,
        fetchScopes: [String]? = nil,
        apiMode: String? = nil,
        apiVersion: String? = nil,
        automaticFetch: Bool? = nil,
        dailyRefresh: Bool? = nil,
        categorize: Bool? = nil,
        createdAt: Date? = nil,
        customFields: [String: String]? = nil,
        deviceType: String? = nil,
        remoteIp: String? = nil,
        excludeAccounts: [Int]? = nil,
        failAt: Date? = nil,
        failErrorClass: String? = nil,
        failMessage: String? = nil,
        finished: Bool? = nil,
        finishedRecent: Bool? = nil,
        interactive: Bool? = nil,
        locale: String? = nil,
        partial: Bool? = nil,
        storeCredentials: Bool? = nil,
        successAt: Date? = nil,
        updatedAt: Date? = nil,
        showConsentConfirmation: Bool? = nil,
        consentTypes: [String]? = nil,
        consentGivenAt: Date? = nil,
        lastStage: SEStage? = nil,
        stages: [SEStage]? = nil,
        returnTo: String? = nil,
        fromDate: Date? = nil,
        toDate: Date? = nil
    ) {
        self.id = id
        self.fetchScopes = fetchScopes
        self.apiMode = apiMode
        self.apiVersion = apiVersion
        self.automaticFetch = automaticFetch
        self.dailyRefresh = dailyRefresh
        self.categorize = categorize
        self.createdAt = createdAt
        self.customFields = customFields
        self.deviceType = deviceType
        self.remoteIp = remoteIp
        self.excludeAccounts = excludeAccounts
        self.failAt = failAt
        self.failErrorClass = failErrorClass
        self.failMessage = failMessage
        self.finished = finished
        self.finishedRecent = finishedRecent
        self.interactive = interactive
        self.locale = locale
        self.partial = partial
        self.storeCredentials = storeCredentials
        self.successAt = successAt
        self.updatedAt = updatedAt
        self.showConsentConfirmation = showConsentConfirmation
        self.consentTypes = consentTypes
        self.consentGivenAt = consentGivenAt
        self.lastStage = lastStage
        self.stages = stages
        self.returnTo = returnTo
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case apiMode = "api_mode"
        case apiVersion = "api_version"
        case automaticFetch = "automatic_fetch"
        case dailyRefresh = "daily_refresh"
        case categorize = "categorize"
        case createdAt = "created_at"
        case customFields = "custom_fields"
        case deviceType = "device_type"
        case remoteIp = "remote_ip"
        case excludeAccounts = "exclude_accounts"
        case failAt = "fail_at"
        case failErrorClass = "fail_error_class"
        case failMessage = "fail_message"
        case fetchScopes = "fetch_scopes"
        case finished = "finished"
        case finishedRecent = "finished_recent"
        case interactive = "interactive"
        case locale = "locale"
        case partial = "partial"
        case storeCredentials = "store_credentials"
        case successAt = "success_at"
        case updatedAt = "updated_at"
        case showConsentConfirmation = "show_consent_confirmation"
        case consentTypes = "consent_types"
        case consentGivenAt = "consent_given_at"
        case lastStage = "last_stage"
        case stages = "stages"
        case returnTo = "return_to"
        case fromDate = "from_date"
        case toDate = "to_date"
    }
}
