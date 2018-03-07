//
//  DateUtilsSpec.swift
//  saltedge-ios_Tests
//
//  Created by Vlad Somov.
//  Copyright (c) 2018 Salt Edge. All rights reserved.
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
                        let expecteDate = DateComponents(calendar: Calendar.current, year: 2018, month: 1, day: 28).date!

                        expect(DateFormatter.yyyyMMdd.date(from: dateString)).to(equal(expecteDate))
                    }
                }

                context("when date given") {
                    it("should return string from date in yyyyMMdd format") {
                        let date = DateComponents(calendar: Calendar.current, year: 2018, month: 1, day: 28).date!
                        let expectedString = "2018-01-28"
                        
                        expect(DateFormatter.yyyyMMdd.string(from: date)).to(equal(expectedString))
                    }
                }
            }

            describe("time") {
                it("should return string from date in time format") {
                    let date = DateComponents(calendar: Calendar.current, hour: 3, minute: 20, second: 30).date!
                    let expectedString = "03:20:30"

                    expect(DateFormatter.time.string(from: date)).to(equal(expectedString))
                }
            }
        }

    }
}
