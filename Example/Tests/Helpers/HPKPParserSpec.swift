//
//  HPKPParserSpec.swift
//  saltedge-ios_Example
//
//  Created by Vlad Somov on 4/17/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import SaltEdge

class HPKPParserSpec: QuickSpec {
    override func spec() {
        describe("parse(_:)") {
            context("when it is valid HPKP string") {
                it("should return pins, maxAge and includeSubdomains option") {
                    let string = "pin-sha256=\"cUPcTAZWKaASuYWhhneDttWpY3oBAkE3h2+soZS7sWs=\"; pin-sha256=\"M8HztCzM3elUxkcjR2S5P4hhyBNf6lHkmjAHKhpGPWE=\"; max-age=5184000; includeSubDomains;"
                    let expectedPins = [
                        "cUPcTAZWKaASuYWhhneDttWpY3oBAkE3h2+soZS7sWs=",
                        "M8HztCzM3elUxkcjR2S5P4hhyBNf6lHkmjAHKhpGPWE="
                    ]
                    let expectedMaxAge: Double = 5184000
                    let expectedIncludeSubDomains: Bool = true

                    let (actualPins, actualMaxAge, actualIncludeSubdomains) = try! HPKPParser.parse(string)

                    expect(actualPins).to(equal(expectedPins))
                    expect(actualMaxAge).to(equal(expectedMaxAge))
                    expect(actualIncludeSubdomains).to(equal(expectedIncludeSubDomains))
                }
            }

            context("when it is valid HPKP string withoud includeSubDomains option") {
                it("should return pins, maxAge options and includeSubdomains as false") {
                    let string = "pin-sha256=\"cUPcTAZWKaASuYWhhneDttWpY3oBAkE3h2+soZS7sWs=\"; pin-sha256=\"M8HztCzM3elUxkcjR2S5P4hhyBNf6lHkmjAHKhpGPWE=\"; max-age=5184000;"
                    let expectedPins = [
                        "cUPcTAZWKaASuYWhhneDttWpY3oBAkE3h2+soZS7sWs=",
                        "M8HztCzM3elUxkcjR2S5P4hhyBNf6lHkmjAHKhpGPWE="
                    ]
                    let expectedMaxAge: Double = 5184000
                    let expectedIncludeSubDomains: Bool = false

                    let (actualPins, actualMaxAge, actualIncludeSubdomains) = try! HPKPParser.parse(string)

                    expect(actualPins).to(equal(expectedPins))
                    expect(actualMaxAge).to(equal(expectedMaxAge))
                    expect(actualIncludeSubdomains).to(equal(expectedIncludeSubDomains))
                }
            }

            context("when pins are missing") {
                it("should throw pinsMissing error") {
                    let string = "max-age=5184000; includeSubDomains;"

                    expect{ try HPKPParser.parse(string) }.to(throwError { (error: HPKPParserError) in
                        expect(error.localizedDescription).to(equal(HPKPParserError.pinsMissing.localizedDescription))
                    })
                }
            }

            context("when maxAge is not a number") {
                it("should throw couldNotParseMaxAge error") {
                    let string = "pin-sha256=\"cUPcTAZWKaASuYWhhneDttWpY3oBAkE3h2+soZS7sWs=\"; pin-sha256=\"M8HztCzM3elUxkcjR2S5P4hhyBNf6lHkmjAHKhpGPWE=\"; max-age=51abc84000;"

                    expect{ try HPKPParser.parse(string) }.to(throwError { (error: HPKPParserError) in
                        expect(error.localizedDescription).to(equal(HPKPParserError.couldNotParseMaxAge.localizedDescription))
                    })
                }
            }

            context("when maxAge is missing") {
                it("should throw maxAgeMissing error") {
                    let string = "pin-sha256=\"cUPcTAZWKaASuYWhhneDttWpY3oBAkE3h2+soZS7sWs=\"; pin-sha256=\"M8HztCzM3elUxkcjR2S5P4hhyBNf6lHkmjAHKhpGPWE=\";"

                    expect{ try HPKPParser.parse(string) }.to(throwError { (error: HPKPParserError) in
                        expect(error.localizedDescription).to(equal(HPKPParserError.maxAgeMissing.localizedDescription))
                    })
                }
            }
        }
    }
}
