import Foundation
import GRDB
import os.log

/// A database of players.
///
/// You create an `AppDatabase` with a connection to an SQLite database
/// (see <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/databaseconnections>).
///
/// Create those connections with a configuration returned from
/// `AppDatabase/makeConfiguration(_:)`.
///
/// For example:
///
/// ```swift
/// // Create an in-memory AppDatabase
/// let config = AppDatabase.makeConfiguration()
/// let dbQueue = try DatabaseQueue(configuration: config)
/// let appDatabase = try AppDatabase(dbQueue)
/// ```
public struct AppDatabase {
    /// Creates an `AppDatabase`, and makes sure the database schema
    /// is ready.
    ///
    /// - important: Create the `DatabaseWriter` with a configuration
    ///   returned by ``makeConfiguration(_:)``.
    init(_ dbWriter: any DatabaseWriter) throws {
        self.dbWriter = dbWriter
        try migrator.migrate(dbWriter)
    }
    
    /// Provides access to the database.
    ///
    /// Application can use a `DatabasePool`, while SwiftUI previews and tests
    /// can use a fast in-memory `DatabaseQueue`.
    ///
    /// See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/databaseconnections>
    let dbWriter: any DatabaseWriter
}

// MARK: - Database Configuration

extension AppDatabase {
    private static let sqlLogger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SQL")
    
    /// Returns a database configuration suited for `PlayerRepository`.
    ///
    /// SQL statements are logged if the `SQL_TRACE` environment variable
    /// is set.
    ///
    /// - parameter base: A base configuration.
    public static func makeConfiguration(_ base: Configuration = Configuration()) -> Configuration {
        var config = base
        
        // An opportunity to add required custom SQL functions or
        // collations, if needed:
        // config.prepareDatabase { db in
        //     db.add(function: ...)
        // }
        
        // Log SQL statements if the `SQL_TRACE` environment variable is set.
        // See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/database/trace(options:_:)>
        if ProcessInfo.processInfo.environment["SQL_TRACE"] != nil {
            config.prepareDatabase { db in
                db.trace {
                    // It's ok to log statements publicly. Sensitive
                    // information (statement arguments) are not logged
                    // unless config.publicStatementArguments is set
                    // (see below).
                    os_log("%{public}@", log: sqlLogger, type: .debug, String(describing: $0))
                }
            }
        }
        
#if DEBUG
        // Protect sensitive information by enabling verbose debugging in
        // DEBUG builds only.
        // See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/configuration/publicstatementarguments>
        config.publicStatementArguments = true
#endif
        
        return config
    }
}

// MARK: - Database Migrations

extension AppDatabase {
    /// The DatabaseMigrator that defines the database schema.
    ///
    /// See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/migrations>
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
#if DEBUG
        // Speed up development by nuking the database when migrations change
        // See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/migrations>
        migrator.eraseDatabaseOnSchemaChange = true
#endif
        
        migrator.registerMigration("initial") { db in
            // Create a table
            // See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/databaseschema>
            try db.create(table: TableNames.config.rawValue) { t in
                t.primaryKey("id", .text).notNull()
                t.column("isNotificationsEnabled", .boolean).notNull()
                t.column("hasSetBedtime", .boolean).notNull()
            }
            
            try db.create(table: TableNames.bedtimeHistory.rawValue) { t in
                t.primaryKey("id", .text).notNull()
                t.column("bedtimeTarget", .double).notNull()
                t.column("inBedTime", .double)
                t.column("status", .text).notNull()
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
            
            try db.create(table: TableNames.bedtime.rawValue) {t in
                t.primaryKey("id", .double).notNull()
                t.column("name", .text).notNull()
                t.column("status", .text).notNull()
                t.column("notificationItems", .jsonText).notNull()
            }
        }
        
        // Migrations for future application versions will be inserted here:
        // migrator.registerMigration(...) { db in
        //     ...
        // }
        
        return migrator
    }
}

// MARK: - Database Access: Writes
// The write methods execute invariant-preserving database transactions.

extension AppDatabase {}

// MARK: - Database Access: Reads

// This demo app does not provide any specific reading method, and instead
// gives an unrestricted read-only access to the rest of the application.
// In your app, you are free to choose another path, and define focused
// reading methods.
extension AppDatabase {
    /// Provides a read-only access to the database
    var reader: DatabaseReader {
        dbWriter
    }
}
