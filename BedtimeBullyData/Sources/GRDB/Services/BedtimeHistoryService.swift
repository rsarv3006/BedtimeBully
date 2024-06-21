import Foundation
import GRDB

public extension AppDatabase {
    func testCreateBedtimeHistory() throws {
        try dbWriter.write { db in
            let testBedtimeHistory = GRDBBedtimeHistory.new(
                bedtimeTarget: Date.now.timeIntervalSince1970,
                inBedTime: Date.now.timeIntervalSince1970,
                status: .valid)
            try testBedtimeHistory.insert(db)
        }
    }
}
