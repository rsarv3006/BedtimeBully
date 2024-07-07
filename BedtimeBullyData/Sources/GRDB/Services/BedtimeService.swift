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

        for index in 0 ..< 7 {
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
            let bedtime = GRDBBedtime.new(date: bedtimeDate, notificationSchedule: notificationSchedule)
            try bedtime.insert(db)

            for notificationItem in bedtime.notificationItems.items {
                let notificationItemId = notificationItem.id
                let notificationDate = Date(timeIntervalSince1970: notificationItemId)

                _ = NotificationService.scheduleNotification(
                    id: String("\(notificationItemId)"),
                    title: "Bedtime Bully",
                    body: notificationItem.message,
                    timestamp: notificationDate
                )
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

    func removeBedtimesAndNotificationsInThePast(currentDate date: Date) throws {
        try dbWriter.write { db in
            let bedtimes = try GRDBBedtime.all().filter(GRDBBedtime.Columns.id < date.timeIntervalSince1970).fetchAll(db)
            var notificationsItems: [NotificationItem] = []
            bedtimes.forEach { notificationsItems.append(contentsOf: $0.notificationItems.items) }
            let notificationsItemIds = notificationsItems.map { $0.idToString() }
            NotificationService.cancelNotifications(ids: notificationsItemIds)

            try bedtimes.forEach { bedtime in
                _ = try createBedtimeHistory(db: db, bedtime: bedtime)
                try bedtime.delete(db)
            }
        }
    }

    func convertBedtimeToHistory(_ bedtime: GRDBBedtime) throws -> GRDBBedtimeHistory {
        try dbWriter.write { db in
            let history = try createBedtimeHistory(db: db, bedtime: bedtime)
            let notificationItemIds = bedtime.notificationItems.items.map { $0.idToString() }
            NotificationService.cancelNotifications(ids: notificationItemIds)
            try bedtime.delete(db)
            return history
        }
    }

    func removeAllBedtimesAndNotifications() throws {
        try dbWriter.write { db in
            let bedtimes = try GRDBBedtime.all().fetchAll(db)

            var notificationItems: [NotificationItem] = []

            for bedtime in bedtimes {
                notificationItems.append(contentsOf: bedtime.notificationItems.items)
                try bedtime.delete(db)
            }

            let notificationItemIds = notificationItems.map { $0.idToString() }

            NotificationService.cancelNotifications(ids: notificationItemIds)
        }
    }
}

public struct GRDBBedtimeDatesAndActiveSchedule {
    public let datesToCreate: [Date]
    public let activeSchedule: GRDBScheduleTemplate
}
