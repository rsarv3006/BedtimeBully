import Foundation
import GRDB

public extension AppDatabase {
    private func createDefaultNotificationSchedules(db: Database) throws {
        if try GRDBNotificationSchedule.all().isEmpty(db) {
            let standardNotificationSchedule = GRDBNotificationSchedule.new(name: NotificationMessageType.Standard.rawValue, notificationItems: StandardNotificationItems, status: .active)
            try standardNotificationSchedule.insert(db)

            let aggressiveNotificationSchedule = GRDBNotificationSchedule.new(name: "Aggressive", notificationItems: AggressiveNotificationItems)
            try aggressiveNotificationSchedule.insert(db)

            let aussieNotificationSchedule = GRDBNotificationSchedule.new(name: "Aussie", notificationItems: AussieNotificationItems)
            try aussieNotificationSchedule.insert(db)
        }
    }

    func createDefaultNotificationSchedules() throws {
        try dbWriter.write { db in
            try createDefaultNotificationSchedules(db: db)
        }
    }

    func setNotificationSchedule(variant name: NotificationMessageType) throws {
        try dbWriter.write { db in
            let allSchedules = try GRDBNotificationSchedule.all().fetchAll(db)

            if allSchedules.count == 1 {
                let scheduleToDelete = allSchedules.first
                try scheduleToDelete?.delete(db)

                try createDefaultNotificationSchedules(db: db)
            }

            let currentActiveSchedule = try GRDBNotificationSchedule.all().filter(GRDBNotificationSchedule.Columns.status == NotificationScheduleStatusVariant.active.rawValue).fetchOne(db)
            if var currentActiveSchedule = currentActiveSchedule {
                currentActiveSchedule.status = .inactive
                try currentActiveSchedule.update(db)
            }

            let newSchedule = try GRDBNotificationSchedule.all().filter(GRDBNotificationSchedule.Columns.name == name.rawValue).fetchOne(db)
            if var newSchedule = newSchedule {
                newSchedule.status = .active
                try newSchedule.update(db)
                try updateNotificationScheduleIdForActiveTemplate(db: db, new: newSchedule.id)
            }
        }
    }

    func getNotificationScheduleById(_ id: String) throws -> GRDBNotificationSchedule? {
        return try dbWriter.read { db in
            try GRDBNotificationSchedule.all().filter(GRDBNotificationSchedule.Columns.id == id).fetchOne(db)
        }
    }
    
    func getNotificationScheduleByName(_ name: String) throws -> GRDBNotificationSchedule? {
        return try dbWriter.read { db in
            try GRDBNotificationSchedule.all().filter(GRDBNotificationSchedule.Columns.name == name).fetchOne(db)
        }
    }
}
