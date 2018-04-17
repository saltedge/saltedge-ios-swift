//
//  SEUserDefaultHelperSpec.swift
//  saltedge-ios_Tests
//
//  Created by Vlad Somov on 4/17/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import SaltEdge

class SEUserDefaultsHelperSpec: QuickSpec {
    override func spec() {
        let defaults = UserDefaults(suiteName: "com.saltedge.sdk")!
        
        beforeEach {
            SEUserDefaultsHelper.clearDefaults()
        }
        
        describe("pins") {
            it("should return pins") {
                expect(SEUserDefaultsHelper.pins).to(beNil())
                
                let pins = ["123456790=", "abacedddse"]
                
                SEUserDefaultsHelper.pins = pins

                expect(SEUserDefaultsHelper.pins).to(equal(pins))
            }
        }
        
        describe("maxAge") {
            it("should return maxAge") {
                expect(SEUserDefaultsHelper.maxAge).to(equal(0.0))
    
                let maxAge: TimeInterval = 51400
                SEUserDefaultsHelper.maxAge = maxAge

                expect(SEUserDefaultsHelper.maxAge).to(equal(maxAge))
            }
        }
        
        describe("includeSubDomains") {
            it("should return the token in the defaults") {
                expect(SEUserDefaultsHelper.includeSubdomains).toNot(beTruthy())
                
                SEUserDefaultsHelper.includeSubdomains = true
                
                expect(SEUserDefaultsHelper.includeSubdomains).to(beTruthy())
            }
        }
        
        describe("clearDefaults") {
            it("should remove everything from the defaults") {
                let key = "key"
                let value = "123"
                defaults.set(value, forKey: key)
                defaults.synchronize()
                
                expect(defaults.object(forKey: key) as? String).to(equal(value))
                
                SEUserDefaultsHelper.clearDefaults()
                
                expect(defaults.object(forKey: key)).to(beNil())
            }
        }
    }
}
