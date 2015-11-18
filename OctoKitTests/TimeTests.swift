//
//  TimeTests.swift
//  OctoKit
//
//  Created by Ben Chatelain on 11/18/15.
//  Copyright © 2015 nerdish by nature. All rights reserved.
//

import XCTest
@testable import OctoKit

class TimeTests: XCTestCase {
    func testDateParsing() {
        //    "pushed_at": "2015-04-28T13:38:52Z",
        let string = "2015-04-28T13:38:52Z"
        let date = Time.rfc3339Date(string)
        XCTAssertNotNil(date)
        XCTAssertEqual(date!, NSDate(timeIntervalSinceReferenceDate: 451921132))
    }
}
