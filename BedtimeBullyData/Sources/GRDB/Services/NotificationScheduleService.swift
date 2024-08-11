import Foundation
import GRDB

public extension AppDatabase {
    func createDefaultNotificationSchedule(notificationItems: [NotificationItem] = DefaultNotificationItems) throws {
        try dbWriter.write { db in
            if try GRDBNotificationSchedule.all().isEmpty(db) {
                let defaultNotificationSchedule = GRDBNotificationSchedule.new(name: "Default", notificationItems: notificationItems)
                try defaultNotificationSchedule.insert(db)
            }
        }
    }

    func replaceNotificationSchedule(with notificationItems: [NotificationItem]) throws {
        try dbWriter.write { db in
            let currentNotificationSchedule = try GRDBNotificationSchedule.all().fetchOne(db)
            if var currentNotificationSchedule = currentNotificationSchedule {
                currentNotificationSchedule.notificationItems = NotificationItems(items: notificationItems)
                try currentNotificationSchedule.update(db)
            } else {
                let defaultNotificationSchedule = GRDBNotificationSchedule.new(name: "Default", notificationItems: notificationItems)
                try defaultNotificationSchedule.insert(db)
            }
        }
    }

    func getNotificationScheduleById(_ id: String) throws -> GRDBNotificationSchedule? {
        return try dbWriter.read { db in
            return try GRDBNotificationSchedule.all().filter(GRDBNotificationSchedule.Columns.id == id).fetchOne(db)
        }
    }
}

