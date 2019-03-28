//
//  UserDefaultsHelper.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import Foundation
import SaltEdge

private enum DefaultsKeys: String {
    case connections
    case customerSecret
}

struct UserDefaultsHelper {
    private static let suiteName = "com.saltedge.demo"
    
    static var connections: [String]? {
        set {
            defaults.set(newValue, forKey: DefaultsKeys.connections.rawValue)
            defaults.synchronize()
        }
        get {
            return defaults.array(forKey: DefaultsKeys.connections.rawValue) as? [String]
        }
    }
    
    static var customerSecret: String? {
        set {
            defaults.set(newValue, forKey: DefaultsKeys.customerSecret.rawValue)
            defaults.synchronize()
        }
        get {
            return defaults.string(forKey: DefaultsKeys.customerSecret.rawValue)
        }
    }
    
    static func clearDefaults() {
        for key in defaults.dictionaryRepresentation().keys {
            defaults.removeObject(forKey: key)
        }
        
        guard let identifier = Bundle.main.bundleIdentifier else {
            defaults.synchronize()
            return
        }
        
        defaults.removePersistentDomain(forName: identifier)
        defaults.synchronize()
    }
    
    private static var defaults: UserDefaults {
        return UserDefaults(suiteName: suiteName)!
    }
}

