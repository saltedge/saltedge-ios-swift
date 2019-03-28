//
//  URLExtensionsSpec.swift
//  saltedge-ios_Tests
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import Quick
import Nimble
@testable import SaltEdge

class URLExtensionsSpec: QuickSpec {
    override func spec() {
        describe("queryParameters") {
            context("when there are no query items") {
                it("should return nil") {
                    let url = APIEndpoints.baseURL.appendingPathComponent("something")
                    
                    expect(url.queryParameters).to(beNil())
                }
            }
            
            context("when there are parameters") {
                it("should return dictionary with parameters") {
                    var urlComponents = URLComponents(url: APIEndpoints.rootURL, resolvingAgainstBaseURL: false)
                    let expectedDictionary = ["id": "2", "name": "test"]
                    
                    var queryItems = [URLQueryItem]()
                    for (key, value) in expectedDictionary {
                        queryItems.append(URLQueryItem(name: key, value: value))
                    }
                    
                    urlComponents?.queryItems = queryItems

                    expect(urlComponents?.url?.queryParameters).to(equal(expectedDictionary))
                }
            }
        }
        
        describe("isCallback") {
            context("when url has scheme saltbridge and host connect") {
                it("should return true") {
                    let url = URL(string: "saltbridge://connect/somedatahere")
                    
                    expect(url?.isCallback).to(beTruthy())
                }
            }
            
            context("when url doesn't have scheme saltbridge and host connect") {
                it("should return false") {
                    let url = URL(string: "somescheme://connect/somedatahere")
                    
                    expect(url?.isCallback).toNot(beTruthy())
                }
            }

            context("when url has scheme saltbridge and doesn't have host connect") {
                it("should return false") {
                    let url = URL(string: "saltbridge://notconnnect/somedatahere")
                    
                    expect(url?.isCallback).toNot(beTruthy())
                }
            }
        }
        
        describe("callbackParameters") {
            context("when response is a SEConnectResposne") {
                it("should return SeConnectResponse and nil error") {
                    let connectParams = "{\"data\": {\"connection_id\": \"1\", \"stage\":\"success\"}}"
                    let url = URL(string: "saltbridge://connect/")?.appendingPathComponent(connectParams)
                   
                    let decoder = JSONDecoder()
                    let expectedConnectParams = try! decoder.decode(SEResponse<SEConnectResponse>.self, from: connectParams.data(using: .utf8)!)

                    let (params, error) = url!.callbackParameters
                    
                    expect(error).to(beNil())
                    expect(params?.connectionId).to(equal(expectedConnectParams.data.connectionId))
                    expect(params?.stage).to(equal(expectedConnectParams.data.stage))
                }
            }
            
            context("when response is a SEConnectResposne") {
                it("should return nil SeConnectResponse and error") {
                    let connectParams = "{\"data\": {\"connection_id\": \"1\"}}"
                    let url = URL(string: "saltbridge://connect/")?.appendingPathComponent(connectParams)
                    
                    let decoder = JSONDecoder()

                    expect { try decoder.decode(SEResponse<SEConnectResponse>.self, from: connectParams.data(using: .utf8)!) }.to(throwError())
                    
                    let (params, error) = url!.callbackParameters
                    
                    expect(error).toNot(beNil())
                    expect(params).to(beNil())
                }
            }
        }
    }
}
