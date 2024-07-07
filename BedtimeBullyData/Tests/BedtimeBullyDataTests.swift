// TODO: Replace with GRDB Test


//import SwiftData
//import XCTest
//
//@testable import BedtimeBullyData
//
//final class BedtimeBullyDataTests: XCTestCase {
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    @MainActor func testGetBedtimeDatesToCreate() throws {
//        let sharedModelContainer: ModelContainer = {
//            let schema = Schema([
//                NotificationSchedule.self,
//                Bedtime.self,
//                BedtimeScheduleTemplate.self,
//                Config.self,
//            ])
//            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//            do {
//                return try ModelContainer(for: schema, configurations: [modelConfiguration])
//            } catch {
//                fatalError("Could not create ModelContainer: \(error)")
//            }
//        }()
//
//        try buildInitialData(sharedModelContainer.mainContext)
//
//        let calendar = Calendar.current
//        let dateThing = calendar.date(from: DateComponents(year: 2023, month: 12, day: 10, hour: 21, minute: 30))!
//
//        let bedtimeDatesAndActiveSchedule = try getBedtimeDatesToCreate(sharedModelContainer.mainContext, now: dateThing)
//
//        XCTAssertEqual(bedtimeDatesAndActiveSchedule.datesToCreate, [
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 10, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 11, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 12, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 13, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 14, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 15, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 16, hour: 21, minute: 45))!,
//        ])
//    }
//
//    @MainActor func testDoesNotBreakOnSaturday() throws {
//        let sharedModelContainer: ModelContainer = {
//            let schema = Schema([
//                NotificationSchedule.self,
//                Bedtime.self,
//                BedtimeScheduleTemplate.self,
//                Config.self,
//            ])
//            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//            do {
//                return try ModelContainer(for: schema, configurations: [modelConfiguration])
//            } catch {
//                fatalError("Could not create ModelContainer: \(error)")
//            }
//        }()
//
//        try buildInitialData(sharedModelContainer.mainContext)
//
//        let calendar = Calendar.current
//        let dateThing = calendar.date(from: DateComponents(year: 2023, month: 12, day: 9, hour: 21, minute: 30))!
//
//        let bedtimeDatesAndActiveSchedule = try getBedtimeDatesToCreate(sharedModelContainer.mainContext, now: dateThing)
//
//        XCTAssertEqual(bedtimeDatesAndActiveSchedule.datesToCreate, [
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 9, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 10, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 11, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 12, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 13, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 14, hour: 21, minute: 45))!,
//            calendar.date(from: DateComponents(year: 2023, month: 12, day: 15, hour: 21, minute: 45))!,
//        ])
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//}
