//
//  SEUserDefaultsHelper.swift
//  Pods
//
//  Created by Vlad Somov on 4/12/18.
//

import Foundation

private enum DefaultsKeys: String {
    case pins
    case maxAge
    case includeSubdomains
}

struct SEUserDefaultsHelper {
    private static let suiteName = "com.saltedge.sdk"
    
    static var pins: [String]? {
        set {
            defaults.set(newValue, forKey: DefaultsKeys.pins.rawValue)
            defaults.synchronize()
        }
        get {
            return defaults.array(forKey: DefaultsKeys.pins.rawValue) as? [String]
        }
    }
    
    static var maxAge: TimeInterval {
        set {
            defaults.set(newValue, forKey: DefaultsKeys.maxAge.rawValue)
            defaults.synchronize()
        }
        get {
            return defaults.double(forKey: DefaultsKeys.maxAge.rawValue)
        }
    }
    
    static var includeSubdomains: Bool {
        set {
            defaults.set(newValue, forKey: DefaultsKeys.includeSubdomains.rawValue)
            defaults.synchronize()
        }
        get {
            return defaults.bool(forKey: DefaultsKeys.includeSubdomains.rawValue)
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
