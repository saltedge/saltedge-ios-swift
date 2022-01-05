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

private class TestParamURLEncodable: ParametersEncodable, URLEncodable {
    let id: Int
    let parentName: String

    init(id: Int, parentName: String) {
        self.id = id
        self.parentName = parentName
    }
}

private class TestChildParamURLEncodable: TestParamURLEncodable {
    let childName: String

    init(childName: String, id: Int, parentName: String) {
        self.childName = childName
        super.init(id: id, parentName: parentName)
    }
}

class URLEncodableSpec: QuickSpec {
    override func spec() {
        describe("encode()") {
            it("should return array of URLQueryItem") {
                let params = TestParamURLEncodable(id: 1, parentName: "Test")

                let expectedQueryItems: [URLQueryItem] = [
                    URLQueryItem(name: "id", value: "1"),
                    URLQueryItem(name: "parent_name", value: "Test")
                ]

                expect(Set(params.encode() as! [URLQueryItem])).to(equal(Set(expectedQueryItems)))
            }
        }

        context("when encoding subclass") {
            it("should encode it's parent attributes as well") {
                let params = TestChildParamURLEncodable(childName: "Child", id: 2, parentName: "Parent")

                let expectedQueryItems = [
                    URLQueryItem(name: "child_name", value: "Child"),
                    URLQueryItem(name: "id", value: "2"),
                    URLQueryItem(name: "parent_name", value: "Parent")
                ]

                expect(Set(params.encode() as! [URLQueryItem])).to(equal(Set(expectedQueryItems)))
            }
        }
    }
}
