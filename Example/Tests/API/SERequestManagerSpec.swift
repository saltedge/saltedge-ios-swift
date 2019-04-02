//
//  SERequestManagerSpec.swift
//  saltedge-ios_Tests
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import Quick
import Nimble
@testable import SaltEdge

class SERequestManagerSpec: QuickSpec {
    override func spec() {
        describe("set(appId:,appSecret:)") {
            it("should set appId and secret in SEHeaders for shared session") {
                SEHeaders.cached.sessionHeaders = SEHeaders.requestHeaders
                let appId = "app-id"
                let secret = "secret"
                
                SERequestManager.shared.set(appId: appId, appSecret: secret)
                
                let expectedHeaders = [ "Accept": "application/json",
                                        "Content-Type": "application/json",
                                        "App-id": appId,
                                        "Secret": secret ]

                expect(SEHeaders.cached.sessionHeaders).to(equal(expectedHeaders))
            }
        }
        
        describe("set(customerSecret:)") {
            it("should set customer secret in SEHeaders for shared session") {
                SEHeaders.cached.sessionHeaders = SEHeaders.requestHeaders
                let customerSecret = "customer secret"
                
                SERequestManager.shared.set(customerSecret: customerSecret)
                
                let expectedHeaders = [ "Accept": "application/json",
                                        "Content-Type": "application/json",
                                        "Customer-secret": customerSecret ]
                
                expect(SEHeaders.cached.sessionHeaders).to(equal(expectedHeaders))
            }
        }
    }
}
