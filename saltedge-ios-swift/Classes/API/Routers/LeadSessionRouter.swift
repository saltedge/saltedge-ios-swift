//
//  LeadSessionRouter.swift
//  SaltEdge-iOS-Swift
//
//  Created by Daniel Marcenco on 8/1/19.
//

import Foundation

enum LeadSessionRouter: Routable {
    case create(SELeadSessionParams)

    var method: HTTPMethod {
        return .post
    }
    
    var query: String {
        return "lead_sessions/create"
    }
    
    var headers: Headers {
        switch self {
        case .create: return SEHeaders.cached.sessionHeaders
        }
    }
    
    var parameters: ParametersEncodable? {
        switch self {
        case .create(let params): return params
        }
    }
}
