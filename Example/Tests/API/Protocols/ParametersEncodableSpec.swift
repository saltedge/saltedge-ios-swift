//
//  ParametersEncodableSpec.swift
//  saltedge-ios_Tests
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import Quick
import Nimble
@testable import SaltEdge

private struct TestParamEncodable: ParametersEncodable, Encodable {
    let id: Int
    let name: String
    let date: Date
    let array: [String]
    let someNumber: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case date
        case array
        case someNumber = "some_number"
    }
}

class ParametersEncodableSpec: QuickSpec {
    override func spec() {
        describe("encode()") {
            it("should return encoded data") {
                let params = TestParamEncodable(id: 1, name: "name", date: Date(), array: ["one", "two", "three"], someNumber: 3.5)
                
                let paramsData = try! params.encode()

                let expectedParams = SERequestParams(data: params)
                let encoder = JSONEncoder()
                encoder.outputFormatting = .sortedKeys
                encoder.dateEncodingStrategy = .iso8601
                let expectedData = try! encoder.encode(expectedParams)

                expect((paramsData as! Data)).to(equal(expectedData))
            }
        }
    }
}
