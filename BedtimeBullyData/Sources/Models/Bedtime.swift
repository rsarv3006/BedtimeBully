//
//  Bedtime.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/28/23.
//

import Foundation
import SwiftData

@Model
public class Bedtime {
    @Attribute(.unique) public let id: TimeInterval
    public let name: String
    public let isActive: Bool

    @Relationship(deleteRule: .cascade)
    public var notificationItems: [NotificationItem]? = []

    public init(date: Date, name: String, isActive: Bool) {
        id = date.timeIntervalSince1970
        self.name = name
        self.isActive = isActive
    }
}

// MARK: - Generate Notification Dates

public extension Bedtime {
    func generateNotificationDates(notificationSchedule: NotificationSchedule?) throws -> [Date] {
        guard let notificationIntervals = notificationSchedule?.notificationIntervals else { throw BedtimeError.notificationScheduleNotSetOnBedtime }
        let bedtime = Date(timeIntervalSince1970: id)

        return notificationIntervals.map { notificationInterval in
            let bedtimeCopy = bedtime
            return bedtimeCopy.addingTimeInterval(-notificationInterval)
        }
    }
}

// MARK: - Bedtime Predicates

public extension Bedtime {
    static func nextBedtimePredicate(_ date: Date) -> Predicate<Bedtime> {
        let nextBedtimePredicate = #Predicate<Bedtime> { bedtime in
            bedtime.isActive == true && bedtime.id > date.timeIntervalSince1970
        }
        return nextBedtimePredicate
    }
}
