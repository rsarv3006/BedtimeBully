import Foundation
import GRDB

public struct GRDBConfig: Identifiable, Equatable {
    public static func == (lhs: GRDBConfig, rhs: GRDBConfig) -> Bool {
        lhs.id == rhs.id
    }

    public var id: String = "config"
    public var isNotificationsEnabled: Bool = false
    public var hasSetBedtime: Bool = false
}

extension GRDBConfig: TableRecord {
    public static let databaseTableName = TableNames.config.rawValue
}

extension GRDBConfig {
    static func new() -> GRDBConfig {
        GRDBConfig()
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBConfig: Codable, FetchableRecord, PersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
        static let isNotificationsEnabled = Column(CodingKeys.isNotificationsEnabled)
        static let hasSetBedtime = Column(CodingKeys.hasSetBedtime)
    }
}

extension DerivableRequest<GRDBConfig> {
}
