//
//  Bedtime.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/28/23.
//

import Foundation
import SwiftData


@Model
class Bedtime {
    let id: UUID
    let name: String
    let bedtimeDay: BedtimeDay
    let isActive: Bool
    let notificationIdentifiers: [UUID] = []
    let bedtime: Date
    
    @Relationship(deleteRule: .cascade) var notificationSchedule: NotificationSchedule?
    
    init(name: String, bedtimeDay: BedtimeDay, isActive: Bool, bedtime: Date) {
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
extension Bedtime {
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
