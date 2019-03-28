//
//  SEConsent.swift
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

public struct SEConsent: Codable {
    public let scopes: [String]
    public let fromDate: Date?
    public let toDate: Date?
    public let periodDays: Int?
    public let expiresAt: Date?
    public let collectedBy: String?
    public let revokedAt: Date?
    public let revokeSession: String?
    public let createdAt: Date?
    public let updatedAt: Date?

    public init(scopes: [String],
                fromDate: Date? = nil,
                toDate: Date? = nil,
                periodDays: Int? = nil,
                expiresAt: Date? = nil,
                collectedBy: String? = nil,
                revokedAt: Date? = nil,
                revokeSession: String? = nil,
                createdAt: Date? = nil,
                updatedAt: Date? = nil) {
        self.scopes = scopes
        self.fromDate = fromDate
        self.toDate = toDate
        self.periodDays = periodDays
        self.expiresAt = expiresAt
        self.collectedBy = collectedBy
        self.revokedAt = revokedAt
        self.revokeSession = revokeSession
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case scopes = "scopes"
        case fromDate = "from_date"
        case toDate = "to_date"
        case periodDays = "period_days"
        case expiresAt = "expires_at"
        case collectedBy = "collected_by"
        case revokedAt = "revoked_at"
        case revokeSession = "revoke_session"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
