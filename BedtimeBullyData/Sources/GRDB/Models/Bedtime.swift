import Foundation
import Notifications
import GRDB

public struct GRDBBedtime: Identifiable, Equatable {
    public static func == (lhs: GRDBBedtime, rhs: GRDBBedtime) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id: TimeInterval
    public let name: String
    public let status: BedtimeStatus
    public let notificationItems: NotificationItems
    
    init(date: Date, notificationSchedule: GRDBNotificationSchedule) {
        self.id = date.timeIntervalSince1970
        self.name = "Bedtime for \(date.timeIntervalSince1970.getPrettyDate())"
        self.status = BedtimeStatus.active
        let notificationDates = GRDBBedtime.generateNotificationDates(bedtimeId: date.timeIntervalSince1970, notificationSchedule: notificationSchedule)
        var notificationItems: [NotificationItem] = []
        
        let bedtime = Date(timeIntervalSince1970: date.timeIntervalSince1970)
        for thing in notificationSchedule.notificationItems.items {
            let interval = thing.id
            let message = thing.message
            
            let bedtimeCopy = bedtime
            let notificationDate = bedtimeCopy.addingTimeInterval(-interval)
            let notificationItem = NotificationItem(id: notificationDate.timeIntervalSince1970, message: message)
            notificationItems.append(notificationItem)
        }
       
        self.notificationItems = NotificationItems(items: notificationItems)
    }
    
    public static func generateNotificationDates(bedtimeId: TimeInterval, notificationSchedule: GRDBNotificationSchedule) -> [Date] {
        let notificationIntervals = notificationSchedule.notificationItems.items
        let bedtime = Date(timeIntervalSince1970: bedtimeId)
        
        return notificationIntervals.map { notificationInterval in
            let bedtimeCopy = bedtime
            return bedtimeCopy.addingTimeInterval(-notificationInterval.id)
        }
    }
    
    public func getPrettyDate() -> String {
        return id.getPrettyDate()
    }
}

extension GRDBBedtime: TableRecord {
    public static let databaseTableName = TableNames.bedtime.rawValue
}

extension GRDBBedtime {
    static func new(date: Date, notificationSchedule: GRDBNotificationSchedule) -> GRDBBedtime {
        GRDBBedtime(date: date, notificationSchedule: notificationSchedule)
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBBedtime: Codable, FetchableRecord, PersistableRecord {
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let notificationItems = Column(CodingKeys.notificationItems)
        static let status = Column(CodingKeys.status)
    }
}

extension DerivableRequest<GRDBBedtime> {
    // TODO: Move over the predicates
}
