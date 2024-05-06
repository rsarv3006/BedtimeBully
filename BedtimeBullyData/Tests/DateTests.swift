import XCTest

final class DateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDayOfWeek() {
        let calendar = Calendar.current

        let sunday = calendar.date(from: DateComponents(year: 2023, month: 12, day: 10))!
        XCTAssertEqual(sunday.dayOfWeek, .Sunday)

        let monday = calendar.date(from: DateComponents(year: 2023, month: 12, day: 11))!
        XCTAssertEqual(monday.dayOfWeek, .Monday)

        let tuesday = calendar.date(from: DateComponents(year: 2023, month: 12, day: 12))!
        XCTAssertEqual(tuesday.dayOfWeek, .Tuesday)

        let wednesday = calendar.date(from: DateComponents(year: 2023, month: 12, day: 13))!
        XCTAssertEqual(wednesday.dayOfWeek, .Wednesday)

        let thursday = calendar.date(from: DateComponents(year: 2023, month: 12, day: 14))!
        XCTAssertEqual(thursday.dayOfWeek, .Thursday)

        let friday = calendar.date(from: DateComponents(year: 2023, month: 12, day: 15))!
        XCTAssertEqual(friday.dayOfWeek, .Friday)

        let saturday = calendar.date(from: DateComponents(year: 2023, month: 12, day: 16))!
        XCTAssertEqual(saturday.dayOfWeek, .Saturday)
    }

    func testIsInPast() {
        let today = Date()

        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        XCTAssertTrue(yesterday.isInPast)

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        XCTAssertFalse(tomorrow.isInPast)

        let distantPast = Calendar.current.date(byAdding: .year, value: -5, to: today)!
        XCTAssertTrue(distantPast.isInPast)

        let distantFuture = Calendar.current.date(byAdding: .year, value: 5, to: today)!
        XCTAssertFalse(distantFuture.isInPast)

        XCTAssertTrue(today.isInPast)
    }

    func testPerformanceOfDayOfWeek() {
        measure {
            let calendar = Calendar.current
            for _ in 0..<1000 {
                let date = calendar.date(from: DateComponents(year: 2023, month: 12, day: 15))!
                _ = date.dayOfWeek
            }
        }
    }

}
