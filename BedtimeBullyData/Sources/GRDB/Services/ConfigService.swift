import Foundation
import GRDB

public extension AppDatabase {
    func createConfig() throws {
        try dbWriter.write { db in
            if try GRDBConfig.all().isEmpty(db){
                let defaultNotificationSchedule = GRDBConfig.new()
                try defaultNotificationSchedule.insert(db)
            }
        }
    }
}
