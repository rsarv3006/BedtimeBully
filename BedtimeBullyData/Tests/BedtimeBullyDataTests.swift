import XCTest
import GRDB

@testable import BedtimeBullyData

final class BedtimeBullyDataTests: XCTestCase {
    var appDb: AppDatabase!

    override func setUpWithError() throws {
        super.setUp()
        appDb = AppDatabase.random()
    }

    override func tearDownWithError() throws {
        appDb = nil
        super.tearDown()
    }

    func testGetBedtimeDatesToCreate() throws {
        let calendar = Calendar.current
        let dateThing = calendar.date(from: DateComponents(year: 2023, month: 12, day: 10, hour: 21, minute: 30))!

        let bedtimeDatesAndActiveSchedule = try appDb.getBedtimeDatesToCreate(now: dateThing)
        
        XCTAssertEqual(bedtimeDatesAndActiveSchedule.datesToCreate, [
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 10, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 11, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 12, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 13, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 14, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 15, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 16, hour: 21, minute: 45))!,
        ])
    }

    func testDoesNotBreakOnSaturday() throws {
        let calendar = Calendar.current
        let dateThing = calendar.date(from: DateComponents(year: 2023, month: 12, day: 9, hour: 21, minute: 30))!

        let bedtimeDatesAndActiveSchedule = try appDb.getBedtimeDatesToCreate(now: dateThing)

        XCTAssertEqual(bedtimeDatesAndActiveSchedule.datesToCreate, [
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 9, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 10, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 11, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 12, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 13, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 14, hour: 21, minute: 45))!,
            calendar.date(from: DateComponents(year: 2023, month: 12, day: 15, hour: 21, minute: 45))!,
        ])
    }

    func testPerformanceExample() throws {
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
