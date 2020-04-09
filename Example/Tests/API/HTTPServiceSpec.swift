//
//  HTTPServiceSpec.swift
//  saltedge-ios_Tests
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import Quick
import Nimble
import Foundation
@testable import SaltEdge

class HTTPServiceSpec: QuickSpec {
    override func spec() {
        describe("handleResponse(from:,error:,decoder:") {
            context("when error passed") {
                it("should return nil data and not nil error") {
                    let expectedError = NSError(domain: "some error domain", code: 123, userInfo: [NSLocalizedDescriptionKey : "error message"]) as Error
                    
                    let (data, error) = handleResponse(from: nil, error: expectedError, decoder: JSONDecoder())
                    
                    expect(data).to(beNil())
                    expect(error).toNot(beNil())
                    expect(error?.localizedDescription).to(equal(expectedError.localizedDescription))
                }
            }
            
            context("when data passed in nil and not error passed") {
                it("should return nil data and not nil error") {
                    let (data, error) = handleResponse(from: nil, error: nil, decoder: JSONDecoder())
                    
                    expect(data).to(beNil())
                    expect(error).toNot(beNil())
                    expect(error?.localizedDescription).to(equal("Data was not retrieved from request"))
                }
            }

            context("when data passed but it is SEError") {
                it("should return SEError as data and nil error") {
                    let errorJson = """
                                        {
                                            "error":
                                                {
                                                    "class": "ConnectionNotFound",
                                                    "message": "Connection with id: '987' was not found.",
                                                    "documentation_url": "https://test.com"
                                                }
                                        }
                                    """
                    let (data, error) = handleResponse(from: errorJson.data(using: .utf8) , error: nil, decoder: JSONDecoder())
                    
                    expect(data).toNot(beNil())
                    expect(error).toNot(beNil())
                    expect(error?.localizedDescription).to(equal("Connection with id: '987' was not found."))
                }
            }
            
            context("when valid data passed") {
                it("should return this data") {
                    let validJson = """
                                        {
                                          "data": "some data",
                                          "key": "value"
                                        }
                                    """
                    let (data, error) = handleResponse(from: validJson.data(using: .utf8), error: nil, decoder: JSONDecoder())
                    
                    expect(error).to(beNil())
                    expect(data).toNot(beNil())
                    expect(data).to(equal(validJson.data(using: .utf8)))
                }
            }
        }
    }
}
