//
//  HPKPParser.swift
//  SaltEdge-iOS-Swift
//
//  Created by Vlad Somov on 4/12/18.
//

import Foundation

enum HPKPParserError: Error {
    case pinsMissing
    case maxAgeMissing
    case couldNotParseMaxAge
}

struct HPKPParser {
    struct Keys {
        static let publicKeyPins = "Public-Key-Pins"
        static let includeSubDomains = "includeSubDomains"
        static let pinSha = "pin-sha256"
        static let maxAge = "max-age"
    }
    
    static func parse(_ string: String) throws -> (pins: [String], maxAge: Double, includeSubdomains: Bool) {
        var pins: [String] = []
        var maxAge: Double!
        var includeSubdomains: Bool = false
        
        let separatedData = string.split(separator: ";", omittingEmptySubsequences: true)

        for parameter in separatedData {
            let cleanedParameter = parameter.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\"", with: "")
            let array = cleanedParameter.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: true)
            
            if array[0] == Keys.includeSubDomains {
                includeSubdomains = true
                continue
            }

            let (key, value) = (String(array[0]), String(array[1]))
            switch key {
            case Keys.pinSha:
                pins.append(value)
            case Keys.maxAge:
                guard let age = Double(value) else { throw HPKPParserError.couldNotParseMaxAge }
                
                maxAge = age
            default: break
            }
        }
        
        guard !pins.isEmpty else { throw HPKPParserError.pinsMissing }
        guard maxAge != nil else { throw HPKPParserError.maxAgeMissing }

        return (pins: pins, maxAge: maxAge, includeSubdomains: includeSubdomains)
    }
}
