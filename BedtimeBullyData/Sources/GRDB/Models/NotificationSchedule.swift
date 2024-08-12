import Foundation
import GRDB

public enum NotificationScheduleStatusVariant: String, Codable {
    case active
    case inactive
}

public struct NotificationItems: Codable, Equatable {
    public var items: [NotificationItem]
}

public struct GRDBNotificationSchedule: Identifiable, Equatable {
    public static func == (lhs: GRDBNotificationSchedule, rhs: GRDBNotificationSchedule) -> Bool {
        lhs.id == rhs.id
    }

    public var id: String
    public let name: String
    public var notificationItems: NotificationItems
    public var status: NotificationScheduleStatusVariant
}

extension GRDBNotificationSchedule: TableRecord {
    public static let databaseTableName = TableNames.notificationSchedule.rawValue
}

extension GRDBNotificationSchedule {
    static func new(name: String, notificationItems: [NotificationItem], status: NotificationScheduleStatusVariant = .inactive) -> GRDBNotificationSchedule {
        GRDBNotificationSchedule(id: UUID().uuidString, name: name, notificationItems: NotificationItems(items: notificationItems), status: status)
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBNotificationSchedule: Codable, FetchableRecord, PersistableRecord {
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let notificationItems = Column(CodingKeys.notificationItems)
        static let status = Column(CodingKeys.status)
    }
}

extension DerivableRequest<GRDBNotificationSchedule> {}
