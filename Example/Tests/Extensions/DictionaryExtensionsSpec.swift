//
//  DictionaryExtensionsSpec.swift
//  saltedge-ios_Tests
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import Quick
import Nimble
@testable import SaltEdge

class DictionaryExtensionsSpec: QuickSpec {
    override func spec() {
        describe("mergeWith(_:)") {
            it("should return merged dictionary") {
                let firstDictionary = ["key": "value", "secondKey": "other value"]
                let secondDictionary = ["key": "newValue", "newKey": "value"]
                
                let expectedDictionary = ["key": "newValue", "secondKey": "other value", "newKey": "value"]
                
                expect(firstDictionary.mergeWith(secondDictionary)).to(equal(expectedDictionary))
            }
        }

    }
}
