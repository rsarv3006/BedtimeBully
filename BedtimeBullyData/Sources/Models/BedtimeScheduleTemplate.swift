//
//  BedtimeScheduleTemplate.swift
//  BedtimeBullyData
//
//  Created by Robert J. Sarvis Jr on 11/28/23.
//

import Foundation
import SwiftData

extension SchemaV1 {
    @Model
    public class BedtimeScheduleTemplate {
        public let id: UUID
        public let name: String
        public let isActive: Bool
        
        public var monday: Time?
        public var tuesday: Time?
        public var wednesday: Time?
        public var thursday: Time?
        public var friday: Time?
        public var saturday: Time?
        public var sunday: Time?
        
        @Relationship(deleteRule: .cascade) public var notificationSchedule: NotificationSchedule?
        
        init(name: String, isActive: Bool) {
            id = UUID()
            self.name = name
            self.isActive = isActive
        }
        
        public func addNotificationSchedule(notificationSchedule: NotificationSchedule) {
            self.notificationSchedule = notificationSchedule
        }
        
        public func setBedtimes(modelContext: ModelContext, monday: Time, tuesday: Time, wednesday: Time, thursday: Time, friday: Time, saturday: Time, sunday: Time) throws {
            self.monday = monday
            self.tuesday = tuesday
            self.wednesday = wednesday
            self.thursday = thursday
            self.friday = friday
            self.saturday = saturday
            self.sunday = sunday
            try modelContext.save()
        }
        
        public func getBedtime(dayOfWeek: Date.DayOfTheWeek?) -> Time? {
            switch dayOfWeek {
            case .Sunday:
                return sunday
            case .Monday:
                return monday
            case .Tuesday:
                return tuesday
            case .Wednesday:
                return wednesday
            case .Thursday:
                return thursday
            case .Friday:
                return friday
            case .Saturday:
                return saturday
            default:
                return nil
            }
        }
        
        public func getBedtime(dayOfWeek: Int) -> Time? {
            switch dayOfWeek {
            case 1:
                return sunday
            case 2:
                return monday
            case 3:
                return tuesday
            case 4:
                return wednesday
            case 5:
                return thursday
            case 6:
                return friday
            case 7:
                return saturday
            default:
                return nil
            }
        }
        
        static func activeBedtimeSchedulePredicate() -> Predicate<BedtimeScheduleTemplate> {
            let activeBedtimeSchedulePredicate = #Predicate<BedtimeScheduleTemplate> { schedule in
                schedule.isActive == true
            }
            return activeBedtimeSchedulePredicate
        }
    }
}
