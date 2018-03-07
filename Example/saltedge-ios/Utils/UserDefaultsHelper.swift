//
//  UserDefaultsHelper.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov.
//  Copyright (c) 2018 Salt Edge. All rights reserved.
//

import Foundation
import SaltEdge

private enum DefaultsKeys: String {
    case logins
    case customerSecret
}

struct UserDefaultsHelper {
    private static let suiteName = "com.saltedge.demo"
    
    static var logins: [String]? {
        set {
            defaults.set(newValue, forKey: DefaultsKeys.logins.rawValue)
            defaults.synchronize()
        }
        get {
            return defaults.array(forKey: DefaultsKeys.logins.rawValue) as? [String]
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

