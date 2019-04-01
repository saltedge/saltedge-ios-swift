//
//  HeadersSpec.swift
//  saltedge-ios_Tests
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import Quick
import Nimble
@testable import SaltEdge

class HeadersSpec: QuickSpec {
    override func spec() {
        let appId = "appid"
        let secret = "secret"
        let customerSecret = "customer secret"

        describe("sessionHeaders") {
            context("when just basic request headers set") {
                it("should return just accept and contentType") {
                    let expectedHeaders = [ "Accept": "application/json",
                                            "Content-Type": "application/json" ]
                    
                    expect(SEHeaders.cached.sessionHeaders).to(equal(expectedHeaders))
                }
            }
        }
        
        describe("set(appId:, appSecret:)") {
            context("when app id and secret is set") {
                it("should return headers with app ID and secret") {
                    let expectedHeaders = [ "Accept": "application/json",
                                            "Content-Type": "application/json",
                                            "App-id": appId,
                                            "Secret": secret ]
                    
                    SEHeaders.cached.set(appId: appId, appSecret: secret)
                    
                    expect(SEHeaders.cached.sessionHeaders).to(equal(expectedHeaders))
                }
            }
        }
        
        describe("set(customerSecret:)") {
            context("when customerSecret is set") {
                it("should return headers with customer secret") {
                    let expectedHeaders = [ "Accept": "application/json",
                                            "Content-Type": "application/json",
                                            "App-id": appId,
                                            "Secret": secret,
                                            "Customer-secret": customerSecret ]
                    
                    SEHeaders.cached.set(customerSecret: customerSecret)
                    
                    expect(SEHeaders.cached.sessionHeaders).to(equal(expectedHeaders))
                }
            }
        }

        describe("set(connectionSecret:)") {
            context("when connectionSecret is set") {
                it("should return headers with provided connection secret") {
                    let connectionSecret = "connection secret"
                    
                    let expectedHeaders = [ "Accept": "application/json",
                                            "Content-Type": "application/json",
                                            "App-id": appId,
                                            "Secret": secret,
                                            "Customer-secret": customerSecret,
                                            "Connection-secret": connectionSecret ]
                    
                    expect(SEHeaders.cached.with(connectionSecret: connectionSecret)).to(equal(expectedHeaders))
                }
            }
        }
    }
}

