//
//  Attempt.swift
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

public struct SEAttempt: Decodable {
    public let id: String
    public let apiMode: String
    public let apiVersion: String
    public let automaticFetch: Bool
    public let dailyRefresh: Bool
    public let categorize: Bool
    public let createdAt: Date
    public let customFields: [String: String]?
    public let deviceType: String
    public let remoteIp: String
    public let excludeAccounts: [Int]
    public let failAt: Date?
    public let failErrorClass: String?
    public let failMessage: String?
    public let fetchScopes: [String]
    public let finished: Bool
    public let finishedRecent: Bool
    public let interactive: Bool
    public let locale: String
    public let partial: Bool
    public let storeCredentials: Bool
    public let successAt: Date?
    public let updatedAt: Date
    public let showConsentConfirmation: Bool?
    public let consentTypes: [String]?
    public let consentGivenAt: Date?
    public let lastStage: SEStage?
    public let stages: [SEStage]?
    
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
        case stages
    }
}

