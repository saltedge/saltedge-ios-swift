//
//  TrustKitHelper.swift
//  SaltEdge-iOS-Swift
//
//  Created by Vlad Somov on 4/17/18.
//

import Foundation
import TrustKit


struct TrustKitHelper {
    private static var alreadySet: Bool = false
        
    static func setup(completion: @escaping (Error?) -> Void) {
        if SEUserDefaultsHelper.maxAge > Date().timeIntervalSince1970 {
            if !alreadySet {
                initTrustKit()
            }
            completion(nil)
        } else {
            getPins { error in
                if let error = error {
                    completion(error)
                } else {
                    initTrustKit()
                    completion(nil)
                }
            }
        }
    }

    private static func initTrustKit() {
        guard let pins = SEUserDefaultsHelper.pins, SEUserDefaultsHelper.maxAge != 0.0 else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let trustKitConfig = [
            kTSKSwizzleNetworkDelegates: false,
            kTSKPinnedDomains: [
                "saltedge.com": [
                    kTSKExpirationDate: dateFormatter.string(from: Date(timeIntervalSince1970: SEUserDefaultsHelper.maxAge)),
                    kTSKPublicKeyHashes: pins,
                    kTSKIncludeSubdomains: SEUserDefaultsHelper.includeSubdomains
                ]
            ]
        ] as [String: Any]
        
        TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
        alreadySet = true
    }
    
    private static func getPins(completion: @escaping (Error?) -> ()) {
        let session = SessionManager.createSession(isSSLPinningEnabled: false)
        
        let task = session.dataTask(with: APIEndpoints.rootURL) { data, response, error in
            savePKP(from: response, completion: completion)
        }
        
        task.resume()
    }
    
    private static func savePKP(from response: URLResponse?, completion: (Error?) -> ()) {
        guard let urlResponse = response as? HTTPURLResponse,
            let headers = urlResponse.allHeaderFields as? [String: Any],
            let pinsString = headers[HPKPParser.Keys.publicKeyPins] as? String else { return }
        
        do {
            let (pins, maxAge, includeSubDomains) = try HPKPParser.parse(pinsString)
            
            SEUserDefaultsHelper.pins = pins
            SEUserDefaultsHelper.maxAge = Date().timeIntervalSince1970 + maxAge
            SEUserDefaultsHelper.includeSubdomains = includeSubDomains
            
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
