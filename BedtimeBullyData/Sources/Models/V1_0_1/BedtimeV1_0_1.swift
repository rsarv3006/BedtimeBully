import Foundation
import Notifications

#if canImport(SwiftData)
    import SwiftData
#endif

@available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
extension SchemaV1_0_1 {
    @Model
    public class Bedtime {
        @Attribute(.unique) public let id: TimeInterval
        public let name: String
        public var status: String = "active"
        public var hasGoneToBed: Bool = false

        public var notificationItems: [NotificationItem] = []

        public init(date: Date, name: String, status: BedtimeStatus) {
            id = date.timeIntervalSince1970
            self.name = name
            self.status = status.rawValue
        }

        public init(date: Date, notificationSchedule: NotificationSchedule) throws {
            id = date.timeIntervalSince1970
            name = "Bedtime for \(date.timeIntervalSince1970.getPrettyDate())"
            status = BedtimeStatus.active.rawValue
            let notificationDates = try generateNotificationDates(notificationSchedule: notificationSchedule)
            var notificationItems: [NotificationItem] = []

            for index in 0 ..< notificationDates.count {
                let notificationDate = notificationDates[index]
                let notifcationItem = NotificationItem(id: TimeInterval(notificationDate.timeIntervalSince1970), message: notificationSchedule.notificationMessages[index])
                notificationItems.append(notifcationItem)
            }

            self.notificationItems = notificationItems
        }

        public func getPrettyDate() -> String {
            return id.getPrettyDate()
        }

        public func generateNotificationDates(notificationSchedule: NotificationSchedule?) throws -> [Date] {
            guard let notificationIntervals = notificationSchedule?.notificationIntervals else { throw BedtimeError.notificationScheduleNotSetOnBedtime }
            let bedtime = Date(timeIntervalSince1970: id)

            return notificationIntervals.map { notificationInterval in
                let bedtimeCopy = bedtime
                return bedtimeCopy.addingTimeInterval(-notificationInterval)
            }
        }

        public func removeUpcomingNotificationsForCurrentBedtime() {
            let notificationItems = self.notificationItems

            let notificationItemIds = notificationItems.map { "\($0.id)" }

            NotificationService.cancelNotifications(ids: notificationItemIds)
        }

        public static func nextBedtimePredicate(_ date: Date) -> Predicate<Bedtime> {
            let nextBedtimePredicate = #Predicate<Bedtime> { bedtime in
                bedtime.status == "active" && bedtime.id > date.timeIntervalSince1970 && bedtime.hasGoneToBed == false
            }
            return nextBedtimePredicate
        }

        public static func bedtimeByIdPredicate(_ id: TimeInterval) -> Predicate<Bedtime> {
            let bedtimeByIdPredicate = #Predicate<Bedtime> { bedtime in
                bedtime.id == id
            }

            return bedtimeByIdPredicate
        }
    }
}
