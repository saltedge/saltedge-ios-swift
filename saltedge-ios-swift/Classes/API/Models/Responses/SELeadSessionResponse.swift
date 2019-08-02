//
//  SELeadSessionResponse.swift
//  SaltEdge-iOS-Swift
//
//  Created by Daniel Marcenco on 8/1/19.
//

import Foundation

public struct SELeadSessionResponse: Decodable {
    public let expiresAt: Date
    public let redirectUrl: String
    
    enum CodingKeys: String, CodingKey {
        case expiresAt = "expires_at"
        case redirectUrl = "redirect_url"
    }
}
