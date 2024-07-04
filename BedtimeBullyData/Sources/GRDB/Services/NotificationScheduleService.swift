import Foundation
import GRDB

public extension AppDatabase {
    func createDefaultNotificationSchedule() throws {
        try dbWriter.write { db in
            if try GRDBNotificationSchedule.all().isEmpty(db) {
                let defaultNotificationSchedule = GRDBNotificationSchedule.new(name: "Default", notificationItems: [
                    NotificationItem(id: TimeInterval(30 * 60), message: "Bedtime in 30 minutes"),
                    NotificationItem(id: TimeInterval(15 * 60), message: "Bedtime in 15 minutes"),
                    NotificationItem(id: TimeInterval(10 * 60), message: "Bedtime in 10 minutes"),
                    NotificationItem(id: TimeInterval(5 * 60), message: "Bedtime in 5 minutes"),
                    NotificationItem(id: TimeInterval(3 * 60), message: "Bedtime in 3 minutes"),
                    NotificationItem(id: TimeInterval(2 * 60), message: "Bedtime in 2 minutes"),
                    NotificationItem(id: TimeInterval(1 * 60), message: "Bedtime in 1 minute"),
                    NotificationItem(id: TimeInterval(-1), message: "Time for Bed!"),
                ])
                try defaultNotificationSchedule.insert(db)
            }
        }
    }

    func getNotificationScheduleById(_ id: String) throws -> GRDBNotificationSchedule? {
        return try dbWriter.read { db in
            try GRDBNotificationSchedule.all().filter(GRDBNotificationSchedule.Columns.id == id).fetchOne(db)
        }
    }
}

