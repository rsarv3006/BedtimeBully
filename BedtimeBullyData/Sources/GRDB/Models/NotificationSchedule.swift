import Foundation
import GRDB

public struct NotificationItems: Codable {
    var items: [NotificationItem]
}

public struct GRDBNotificationSchedule: Identifiable, Equatable {
    public static func == (lhs: GRDBNotificationSchedule, rhs: GRDBNotificationSchedule) -> Bool {
        lhs.id == rhs.id
    }

    public var id: String
    public let name: String
    public let notificationItems: NotificationItems
}

extension GRDBNotificationSchedule: TableRecord {
    public static let databaseTableName = TableNames.notificationSchedule.rawValue
}

extension GRDBNotificationSchedule {
    static func new(name: String, notificationItems: [NotificationItem]) -> GRDBNotificationSchedule {
        GRDBNotificationSchedule(id: UUID().uuidString, name: name, notificationItems: NotificationItems(items: notificationItems))
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBNotificationSchedule: Codable, FetchableRecord, PersistableRecord {
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let notificationItems = Column(CodingKeys.notificationItems)
    }
}

extension DerivableRequest<GRDBNotificationSchedule> {}
