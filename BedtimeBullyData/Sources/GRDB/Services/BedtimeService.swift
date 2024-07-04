import Foundation
import GRDB
import Notifications

public extension AppDatabase {
    func testBedtimeCreate() throws {
        try dbWriter.write { db in
            let schedules = try GRDBNotificationSchedule.all().fetchAll(db)

            guard let schedule = schedules.first else { return }

            let testBedtime = GRDBBedtime.new(date: Date(), notificationSchedule: schedule)
            try testBedtime.insert(db)
        }
    }

    func getActiveBedtimes() throws -> [GRDBBedtime] {
        try dbWriter.read { db in
            let bedtimes = try GRDBBedtime.all().filter(GRDBBedtime.Columns.status == BedtimeStatus.active.rawValue).fetchAll(db)
            return bedtimes
        }
    }

    func getBedtimeDatesToCreate(now: Date) throws -> GRDBBedtimeDatesAndActiveSchedule {
        let schedule = try getActiveScheduleTemplate()
        var datesToCreate: [Date] = []

        guard let schedule else {
            throw BedtimeError.noActiveScheduleTemplate
        }

        let bedtimes = try getActiveBedtimes()

        let calendar = Calendar.current

        for index in 0 ..< 30 {
            let dateSection = calendar.date(byAdding: .day, value: index, to: now)
            let dayOfWeek = dateSection?.dayOfWeek

            let scheduleBedtimeItem = schedule.getBedtime(dayOfWeek: dayOfWeek)
            if let scheduleBedtimeItem,
               scheduleBedtimeItem.isEnabled,
               let dateSection
            {
                let timeForBedtime = scheduleBedtimeItem.time
                let bedtimeDate = calendar.date(bySettingHour: timeForBedtime.hour, minute: timeForBedtime.minute, second: 0, of: dateSection)

                if let bedtimeDate, bedtimes.first(where: { $0.id == bedtimeDate.timeIntervalSince1970 }) == nil {
                    datesToCreate.append(bedtimeDate)
                }
            }
        }

        return GRDBBedtimeDatesAndActiveSchedule(datesToCreate: datesToCreate, activeSchedule: schedule)
    }

    func grdbCreateBedtimeAndNotificationsForDate(bedtimeDate: Date, notificationSchedule: GRDBNotificationSchedule) throws {
        try dbWriter.write { db in
            let testBedtime = GRDBBedtime.new(date: bedtimeDate, notificationSchedule: notificationSchedule)
            try testBedtime.insert(db)
            
            let notificationItems = notificationSchedule.notificationItems.items
            
            for notificationItem in notificationItems {
                let notificationItemId = notificationItem.idToString()
                let notificationItem = NotificationItem(id: notificationItem.id, message: notificationItem.message)
                let notificationDate = Date(timeIntervalSince1970: notificationItem.id)
                
                let _ = NotificationService.scheduleNotification(
                id: notificationItemId,
                title: "Bedtime Bully",
                body: notificationItem.message,
                timestamp: notificationDate)
            }
        }
    }

    func addBedtimesFromSchedule() throws {
        let now = Date()
        let bedtimeDates = try getBedtimeDatesToCreate(now: now)

        let scheduleId = bedtimeDates.activeSchedule.notificationScheduleId

        let notificationSchedule = try getNotificationScheduleById(scheduleId)

        guard let notificationSchedule else {
            throw BedtimeError.noActiveScheduleTemplate
        }

        for bedtimeDate in bedtimeDates.datesToCreate {
            if bedtimeDate.timeIntervalSince1970 > now.timeIntervalSince1970 {
                try grdbCreateBedtimeAndNotificationsForDate(bedtimeDate: bedtimeDate, notificationSchedule: notificationSchedule)
            }
        }
    }
}

public struct GRDBBedtimeDatesAndActiveSchedule {
    public let datesToCreate: [Date]
    public let activeSchedule: GRDBScheduleTemplate
}