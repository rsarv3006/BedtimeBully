import Foundation
import GRDB

public extension AppDatabase {
    func createConfig() throws {
        try dbWriter.write { db in
            if try GRDBConfig.all().isEmpty(db) {
                let defaultNotificationSchedule = GRDBConfig.new()
                try defaultNotificationSchedule.insert(db)
            }
        }
    }

    func updateConfig(isNotificationsEnabled: Bool, hasSetBedtime: Bool) throws {
        try dbWriter.write { db in
            guard var config = try GRDBConfig.all().fetchOne(db) else {
                throw BedtimeError.noConfig
            }

            config.isNotificationsEnabled = isNotificationsEnabled
            config.hasSetBedtime = hasSetBedtime
            try config.update(db)
        }
    }

    func getConfig() throws -> GRDBConfig? {
        let config = try dbWriter.read { db in
            try GRDBConfig.all().fetchOne(db)
        }

        return config
    }
}
