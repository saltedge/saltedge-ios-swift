//
//  URLEncodableSpec.swift
//  saltedge-ios_Tests
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import Quick
import Nimble
@testable import SaltEdge

private struct TestParamURLEncodable: ParametersEncodable, URLEncodable {
    let id: Int
    let someName: String
}

class URLEncodableSpec: QuickSpec {
    override func spec() {
        describe("encode()") {
            it("should return array of URLQueryItem") {
                let params = TestParamURLEncodable(id: 1, someName: "some name")
                
                let expectedQueryItems = [
                    URLQueryItem(name: "id", value: "\(params.id)"),
                    URLQueryItem(name: "some_name", value: params.someName)
                ]
                
                expect(Set(params.encode() as! [URLQueryItem])).to(equal(Set(expectedQueryItems)))
            }
        }
    }
}
