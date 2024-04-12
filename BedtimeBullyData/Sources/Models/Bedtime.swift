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
    public let id: UUID
    public let name: String
    public let bedtimeDay: BedtimeDay
    public let isActive: Bool
    public let notificationIdentifiers: [UUID] = []
    public let bedtime: Time
    
    @Relationship(deleteRule: .cascade) var notificationSchedule: NotificationSchedule?
    
    public init(name: String, bedtimeDay: BedtimeDay, isActive: Bool, bedtime: Time) {
        self.id = UUID()
        self.name = name
        self.bedtimeDay = bedtimeDay
        self.isActive = isActive
        self.bedtime = bedtime
    }
    
    func addNotificationSchedule(notificationSchedule: NotificationSchedule) {
        self.notificationSchedule = notificationSchedule
    }
    
}


// MARK - Generate Notification Dates
public extension Bedtime {
    func generateNotificationDates(dateForBedtime: Date) throws -> [Date] {
        guard let notificationIntervals = notificationSchedule?.notificationIntervals else { throw BedtimeError.notificationScheduleNotSetOnBedtime }
        let bedtime = DateComponents(calendar: Calendar.current, month: dateForBedtime.month, day: dateForBedtime.day, hour: self.bedtime.hour, minute: self.bedtime.minute).date
       
        guard let bedtime else { throw BedtimeError.failedToCreateBedtimeDate }
        
        return notificationIntervals.map { notificationInterval in
            let bedtimeCopy = bedtime
            return bedtimeCopy.addingTimeInterval(-notificationInterval)
        }
    }
}
