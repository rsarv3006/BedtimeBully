import XCTest
@testable import BedtimeBullyData

class BedtimeStreakTests: XCTestCase {
    let schedule = GRDBNotificationSchedule(id: "1", name: "Test", notificationItems: NotificationItems(items: []), status: .active)
    
    func testEmptyBedtimes() throws {
        let bedtimes: [GRDBBedtime] = []
        let streak = try parseBedtimesForStreak(bedtimes: bedtimes)
        XCTAssertEqual(streak, 0, "Streak should be 0 for empty bedtimes array")
    }
    
    func testAllValidBedtimes() throws {
        var bedtime1 = GRDBBedtime(date: Date(timeIntervalSince1970: 1100), notificationSchedule: schedule)
        bedtime1.timeWentToBed = Date(timeIntervalSince1970: 1000).timeIntervalSince1970
        var bedtime2 = GRDBBedtime(date: Date(timeIntervalSince1970: 2100), notificationSchedule: schedule)
        bedtime2.timeWentToBed = Date(timeIntervalSince1970: 2000).timeIntervalSince1970
        var bedtime3 = GRDBBedtime(date: Date(timeIntervalSince1970: 3100), notificationSchedule: schedule)
        bedtime3.timeWentToBed = Date(timeIntervalSince1970: 3000).timeIntervalSince1970

        let bedtimes = [bedtime1, bedtime2, bedtime3]
        
        let streak = try parseBedtimesForStreak(bedtimes: bedtimes)
        XCTAssertEqual(streak, 3, "Streak should be 3 for all valid bedtimes")
    }
    
    func testStreakBreaksOnInvalidBedtime() throws {
        var bedtime1 = GRDBBedtime(date: Date(timeIntervalSince1970: 1100), notificationSchedule: schedule)
        bedtime1.timeWentToBed = Date(timeIntervalSince1970: 1000).timeIntervalSince1970
        var bedtime2 = GRDBBedtime(date: Date(timeIntervalSince1970: 2000), notificationSchedule: schedule)
        bedtime2.timeWentToBed = Date(timeIntervalSince1970: 2100).timeIntervalSince1970 // Invalid
        var bedtime3 = GRDBBedtime(date: Date(timeIntervalSince1970: 3100), notificationSchedule: schedule)
        bedtime3.timeWentToBed = Date(timeIntervalSince1970: 3000).timeIntervalSince1970

        let bedtimes = [bedtime1, bedtime2, bedtime3]
        
        let streak = try parseBedtimesForStreak(bedtimes: bedtimes)
        XCTAssertEqual(streak, 1, "Streak should break at the first invalid bedtime")
    }
    
    func testStreakWithSomeMissingTimeWentToBed() throws {
        var bedtime1 = GRDBBedtime(date: Date(timeIntervalSince1970: 1100), notificationSchedule: schedule)
        bedtime1.timeWentToBed = Date(timeIntervalSince1970: 1000).timeIntervalSince1970
        let bedtime2 = GRDBBedtime(date: Date(timeIntervalSince1970: 2100), notificationSchedule: schedule)
        // timeWentToBed is nil for bedtime2
        var bedtime3 = GRDBBedtime(date: Date(timeIntervalSince1970: 3100), notificationSchedule: schedule)
        bedtime3.timeWentToBed = Date(timeIntervalSince1970: 3000).timeIntervalSince1970

        let bedtimes = [bedtime1, bedtime2, bedtime3]
        
        let streak = try parseBedtimesForStreak(bedtimes: bedtimes)
        XCTAssertEqual(streak, 1, "Streak should break when timeWentToBed is nil")
    }
    
    func testStreakWithAllMissingTimeWentToBed() throws {
        let bedtime1 = GRDBBedtime(date: Date(timeIntervalSince1970: 1100), notificationSchedule: schedule)
        let bedtime2 = GRDBBedtime(date: Date(timeIntervalSince1970: 2100), notificationSchedule: schedule)
        let bedtime3 = GRDBBedtime(date: Date(timeIntervalSince1970: 3100), notificationSchedule: schedule)

        let bedtimes = [bedtime1, bedtime2, bedtime3]
        
        let streak = try parseBedtimesForStreak(bedtimes: bedtimes)
        XCTAssertEqual(streak, 0, "Streak should be 0 when all timeWentToBed are nil")
    }
}
