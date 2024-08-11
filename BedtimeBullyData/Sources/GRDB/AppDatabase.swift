import Foundation
import GRDB
import os.log

public struct AppDatabase {
    init(_ dbWriter: any DatabaseWriter) throws {
        self.dbWriter = dbWriter
        try migrator.migrate(dbWriter)
    }

    let dbWriter: any DatabaseWriter
}

// MARK: - Database Configuration

extension AppDatabase {
    private static let sqlLogger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SQL")

    public static func makeConfiguration(_ base: Configuration = Configuration()) -> Configuration {
        var config = base

        if ProcessInfo.processInfo.environment["SQL_TRACE"] != nil {
            config.prepareDatabase { db in
                db.trace {
                    os_log("%{public}@", log: sqlLogger, type: .debug, String(describing: $0))
                }
            }
        }

        #if DEBUG
            config.publicStatementArguments = true
        #endif

        return config
    }
}

// MARK: - Database Migrations

extension AppDatabase {
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        #if DEBUG
            migrator.eraseDatabaseOnSchemaChange = false
        #endif

        migrator.registerMigration("initial") { db in
            try db.create(table: TableNames.config.rawValue) { t in
                t.primaryKey("id", .text).notNull()
                t.column("isNotificationsEnabled", .boolean).notNull()
                t.column("hasSetBedtime", .boolean).notNull()
            }

            try db.create(table: TableNames.notificationSchedule.rawValue) { t in
                t.primaryKey("id", .text).notNull()
                t.column("name", .text).notNull()
                t.column("notificationItems", .jsonText).notNull()
            }

            try db.create(table: TableNames.ScheduleTemplate.rawValue) { t in
                t.primaryKey("id", .text).notNull()
                t.column("name", .text).notNull()
                t.column("isActive", .boolean).notNull()

                t.column("monday", .jsonText).notNull()
                t.column("tuesday", .jsonText).notNull()
                t.column("wednesday", .jsonText).notNull()
                t.column("thursday", .jsonText).notNull()
                t.column("friday", .jsonText).notNull()
                t.column("saturday", .jsonText).notNull()
                t.column("sunday", .jsonText).notNull()

                t.column("notificationScheduleId", .text).notNull()
            }

            try db.create(table: TableNames.bedtime.rawValue) { t in
                t.primaryKey("id", .double).notNull()
                t.column("name", .text).notNull()
                t.column("status", .text).notNull()
                t.column("notificationItems", .jsonText).notNull()
                t.column("timeWentToBed", .double)
            }
        }

        // Migrations for future application versions will be inserted here:
        // migrator.registerMigration(...) { db in
        //     ...
        // }

        migrator.registerMigration("20240811:1 - Add Status Notification Schedule - update default") { db in
            try db.alter(table: TableNames.notificationSchedule.rawValue) { t in
                t.add(column: "status", .text).notNull().defaults(to: "inactive")
            }

            try db.execute(sql: """
                UPDATE notificationSchedule
                SET status = 'active' 
                WHERE name = 'Default'
            """)
            
            try db.execute(literal: """
                UPDATE notificationSchedule
                SET name = 'Standard'
                WHERE name = 'Default' OR name = 'Standard'
            """)
        }

        return migrator
    }
}

extension AppDatabase {}

extension AppDatabase {
    var reader: DatabaseReader {
        dbWriter
    }
}
