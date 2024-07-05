import Foundation
import GRDB

public struct GRDBBedtimeHistory: Identifiable, Equatable {
    public static func == (lhs: GRDBBedtimeHistory, rhs: GRDBBedtimeHistory) -> Bool {
        lhs.id == rhs.id
    }

    public var id: String
    public var bedtimeTarget: TimeInterval
    public let inBedTime: TimeInterval?
    public let status: BedtimeHistoryStatus

    init(bedtimeTarget: TimeInterval, status: BedtimeHistoryStatus, inBedTime: TimeInterval?) {
        id = UUID().uuidString
        self.bedtimeTarget = bedtimeTarget
        self.inBedTime = inBedTime
        self.status = status
    }
}

extension GRDBBedtimeHistory: TableRecord {
    public static let databaseTableName = TableNames.bedtimeHistory.rawValue
}

public extension GRDBBedtimeHistory {
    static func new(bedtimeTarget: TimeInterval, status: BedtimeHistoryStatus, inBedTime: TimeInterval?) -> GRDBBedtimeHistory {
        GRDBBedtimeHistory(bedtimeTarget: bedtimeTarget, status: status, inBedTime: inBedTime)
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBBedtimeHistory: Codable, FetchableRecord, PersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
        static let bedtimeTarget = Column(CodingKeys.bedtimeTarget)
        static let inBedTime = Column(CodingKeys.inBedTime)
        static let status = Column(CodingKeys.status)
    }
}

extension DerivableRequest<GRDBBedtimeHistory> {}
