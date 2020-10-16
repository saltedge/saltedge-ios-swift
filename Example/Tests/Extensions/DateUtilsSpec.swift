//
//  DateUtilsSpec.swift
//  saltedge-ios_Tests
//
//  Created by Vlad Somov.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import Quick
import Nimble
@testable import SaltEdge

class DateUtilsSpec: QuickSpec {
    override func spec() {
        describe("DateFormatter") {
            describe("yyMMdd") {
                context("when date string is given") {
                    it("should return date from string in yyyyMMdd format") {
                        let dateString = "2018-01-28"

                        var dateComponents = DateComponents()
                        dateComponents.year = 2018
                        dateComponents.month = 1
                        dateComponents.day = 28
                        dateComponents.timeZone = TimeZone.utc

                        let calendar = Calendar(identifier: .iso8601)
                        let expectedDate = calendar.date(from: dateComponents)

                        expect(DateFormatter.yyyyMMdd.date(from: dateString)).to(equal(expectedDate))
                    }
                }

                context("when date given") {
                    it("should return string from date in yyyyMMdd format") {
                        var dateComponents = DateComponents()
                        dateComponents.year = 2018
                        dateComponents.month = 1
                        dateComponents.day = 28
                        dateComponents.timeZone = TimeZone.utc

                        let calendar = Calendar(identifier: .iso8601)
                        let date = calendar.date(from: dateComponents)!

                        let expectedString = "2018-01-28"
                        
                        expect(DateFormatter.yyyyMMdd.string(from: date)).to(equal(expectedString))
                    }
                }
            }

            describe("iso8601DateTime") {
                context("when date string is given") {
                    it("should return date from string in iso8601DateTime format") {
                        let dateString = "2020-10-16T14:31:21Z"

                        var dateComponents = DateComponents()
                        dateComponents.year = 2020
                        dateComponents.month = 10
                        dateComponents.day = 16
                        dateComponents.hour = 14
                        dateComponents.minute = 31
                        dateComponents.second = 21
                        dateComponents.timeZone = TimeZone.utc

                        let calendar = Calendar(identifier: .iso8601)
                        let expectedDate = calendar.date(from: dateComponents)

                        expect(DateFormatter.iso8601DateTime.date(from: dateString)).to(equal(expectedDate))
                    }
                }
            }

            describe("time") {
                it("should return string from date in time format") {
                    var dateComponents = DateComponents()
                    dateComponents.timeZone = TimeZone.utc
                    dateComponents.hour = 03
                    dateComponents.minute = 20
                    dateComponents.second = 30

                    let calendar = Calendar(identifier: .iso8601)
                    let date = calendar.date(from: dateComponents)!

                    let expectedString = "03:20:30"

                    expect(DateFormatter.time.string(from: date)).to(equal(expectedString))
                }
            }
        }

    }
}
