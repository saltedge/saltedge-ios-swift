//
//  RoutableSpec.swift
//  saltedge-ios_Tests
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import Quick
import Nimble
@testable import SaltEdge

private struct TestParams: Encodable, ParametersEncodable {
    let id: Int
    let someName: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case someName = "some_name"
    }
}

private struct TestURLParams: URLEncodable, ParametersEncodable {
    let fromId: Int
    let someString: String
}

private enum TestRouter: Routable {
    case show(String)
    case create(TestParams)
    case getWithParams(TestURLParams)
    case put(TestParams, String)
    case delete(String)
    
    var method: HTTPMethod {
        switch self {
        case .show, .getWithParams: return .get
        case .create: return .post
        case .put: return .put
        case .delete: return .delete
        }
    }
    
    var url: URL {
        switch self {
        case .show: return APIEndpoints.baseURL.appendingPathComponent("get/route")
        case .getWithParams: return APIEndpoints.baseURL.appendingPathComponent("get/test")
        case .create: return APIEndpoints.baseURL.appendingPathComponent("create/route")
        case .put: return APIEndpoints.baseURL.appendingPathComponent("put/route")
        case .delete: return APIEndpoints.baseURL.appendingPathComponent("delete/route")
        }
    }
    
    var headers: Headers {
        switch self {
        case .show(let connectionSecret): return SEHeaders.cached.with(connectionSecret: connectionSecret)
        case .create: return SEHeaders.cached.sessionHeaders
        case .getWithParams: return SEHeaders.cached.sessionHeaders
        case .put(_, let connectionSecret): return SEHeaders.cached.with(connectionSecret: connectionSecret)
        case .delete(let connectionSecret): return SEHeaders.cached.with(connectionSecret: connectionSecret)
        }
    }
    
    var parameters: ParametersEncodable? {
        switch self {
        case .show, .delete: return nil
        case .create(let params): return params
        case .getWithParams(let params): return params
        case .put(let params, _): return params
        }
    }
}

class RoutableSpec: QuickSpec {
    override func spec() {
        describe("APIEndpoints") {
            it("should return root url") {
                expect(APIEndpoints.rootURL).to(equal(URL(string: "https://www.saltedge.com")!))
            }
            
            it("should return base url") {
                expect(APIEndpoints.baseURL).to(equal(URL(string: "https://www.saltedge.com/api/v5")!))
            }
        }
        
        describe("asURLRequest()") {
            context("when get method with, url and connectionSecret in headers are set") {
                it("should return correct url request") {
                    SEHeaders.cached.sessionHeaders = SEHeaders.requestHeaders
                    
                    let connectionSecret = "connection secret"
                    let request = TestRouter.show(connectionSecret).asURLRequest()
                    

                    let expectedHeaders = [ "Accept": "application/json",
                                            "Content-Type": "application/json",
                                            "Connection-secret": connectionSecret ]
                    
                    expect(request.allHTTPHeaderFields).to(equal(expectedHeaders))
                    expect(request.httpMethod).to(equal("GET"))
                    expect(request.url).to(equal(APIEndpoints.baseURL.appendingPathComponent("get/route")))
                    expect(request.httpBody).to(beNil())
                }
            }
            
            context("when post method, url and parameters set") {
                it("should return correct url request") {
                    SEHeaders.cached.sessionHeaders = SEHeaders.requestHeaders
                    
                    let params = TestParams(id: 1, someName: "name")
                    let request = TestRouter.create(params).asURLRequest()
                    
                    
                    let expectedHeaders = [ "Accept": "application/json",
                                            "Content-Type": "application/json" ]
                    
                    expect(request.allHTTPHeaderFields).to(equal(expectedHeaders))
                    expect(request.httpMethod).to(equal("POST"))
                    expect(request.url).to(equal(APIEndpoints.baseURL.appendingPathComponent("create/route")))
                    expect(request.httpBody).to(equal(try! params.encode() as! Data))
                }
            }
            
            context("when get method, url and URL parameters set") {
                it("should return correct url request") {
                    SEHeaders.cached.sessionHeaders = SEHeaders.requestHeaders
                    
                    let params = TestURLParams(fromId: 1, someString: "test test")
                    let request = TestRouter.getWithParams(params).asURLRequest()
                    
                    
                    let expectedHeaders = [ "Accept": "application/json",
                                            "Content-Type": "application/json" ]
                    
                    var expectedURLComponents = URLComponents(url: APIEndpoints.baseURL.appendingPathComponent("get/test"), resolvingAgainstBaseURL: false)
                    expectedURLComponents?.queryItems = [ URLQueryItem(name: "from_id", value: String(params.fromId)),
                                                          URLQueryItem(name: "some_string", value: params.someString) ]
                    expect(request.allHTTPHeaderFields).to(equal(expectedHeaders))
                    expect(request.httpMethod).to(equal("GET"))
                    expect(request.httpBody).to(beNil())
                }
            }
            
            context("when put method, url, headers and parameters set") {
                it("should return correct url request") {
                    SEHeaders.cached.sessionHeaders = SEHeaders.requestHeaders
                    
                    let connectionSecret = "connection secret"
                    let params = TestParams(id: 5, someName: "something else")
                    let request = TestRouter.put(params, connectionSecret).asURLRequest()
                    
                    
                    let expectedHeaders = [ "Accept": "application/json",
                                            "Content-Type": "application/json",
                                            "Connection-secret": connectionSecret ]

                    expect(request.allHTTPHeaderFields).to(equal(expectedHeaders))
                    expect(request.httpMethod).to(equal("PUT"))
                    expect(request.url).to(equal(APIEndpoints.baseURL.appendingPathComponent("put/route")))
                    expect(request.httpBody).to(equal(try! params.encode() as! Data))
                }
            }
            
            context("when delete method with, url and connectionSecret in headers are set") {
                it("should return correct url request") {
                    SEHeaders.cached.sessionHeaders = SEHeaders.requestHeaders
                    
                    let connectionSecret = "connection secret"
                    let request = TestRouter.delete(connectionSecret).asURLRequest()
                    
                    
                    let expectedHeaders = [ "Accept": "application/json",
                                            "Content-Type": "application/json",
                                            "Connection-secret": connectionSecret ]
                    
                    expect(request.allHTTPHeaderFields).to(equal(expectedHeaders))
                    expect(request.httpMethod).to(equal("DELETE"))
                    expect(request.url).to(equal(APIEndpoints.baseURL.appendingPathComponent("delete/route")))
                    expect(request.httpBody).to(beNil())
                }
            }
        }
    }
}

