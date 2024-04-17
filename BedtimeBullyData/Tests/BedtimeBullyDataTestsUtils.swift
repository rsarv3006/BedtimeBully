//
//  BedtimeBullyDataTestsUtils.swift
//  BedtimeBullyDataTests
//
//  Created by Robert J. Sarvis Jr on 11/23/23.
//

import XCTest
@testable import BedtimeBullyData

final class BedtimeBullyDataTestsUtils: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUtilTimeUntilBed() throws {

    }

    func testUtilFirstNotifyTime() throws {
        let bedtime = DateComponents(calendar: .current, year: 2023, month: 12, day: 25, hour: 18, minute: 30).date!
        let expectedOffset = DateComponents(calendar: .current, year: 2023, month: 12, day: 25, hour: 18, minute: 0).date!
        let notifyOffset: TimeInterval = 30 * 60

        let calculatedOffset = DataUtils.calculateNotificationTime(bedtime: bedtime, notificationOffset: notifyOffset)
       XCTAssertEqual(calculatedOffset, expectedOffset)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
