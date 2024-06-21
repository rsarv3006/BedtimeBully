import Foundation
import GRDB

public extension AppDatabase {
    func testBedtimeCreate() throws {
        try dbWriter.write { db in
            let schedules = try GRDBNotificationSchedule.all().fetchAll(db)
            
                        
            guard let schedule = schedules.first else {return}

            let testBedtime = GRDBBedtime.new(date: Date(), notificationSchedule: schedule)
            try testBedtime.insert(db)
        }
    }
}

