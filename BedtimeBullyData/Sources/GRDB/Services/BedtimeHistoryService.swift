import Foundation
import GRDB

public extension AppDatabase {
    func testCreateBedtimeHistory() throws {
        try dbWriter.write { db in
            let testBedtimeHistory = GRDBBedtimeHistory.new(
                bedtimeTarget: Date.now.timeIntervalSince1970,
                status: .valid,
                inBedTime: Date.now.timeIntervalSince1970
            )
            try testBedtimeHistory.insert(db)
        }
    }

    func createBedtimeHistory(db: Database, bedtime: GRDBBedtime) throws -> GRDBBedtimeHistory {
        let bedtimeHistory = GRDBBedtimeHistory.new(
            bedtimeTarget: bedtime.id,
            status: .valid,
            inBedTime: bedtime.id
        )
        try bedtimeHistory.insert(db)
        return bedtimeHistory
    }
}
