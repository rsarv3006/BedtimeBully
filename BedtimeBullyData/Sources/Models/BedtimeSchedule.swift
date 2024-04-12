//
//  BedtimeSchedule.swift
//  BedtimeBullyData
//
//  Created by Robert J. Sarvis Jr on 11/28/23.
//

import Foundation
import SwiftData

@Model
public class BedtimeSchedule {
    public let id: UUID
    public let name: String
    public let isActive: Bool
    
    @Relationship(deleteRule: .cascade) var monday: Bedtime?
    @Relationship(deleteRule: .cascade) var tuesday: Bedtime?
    @Relationship(deleteRule: .cascade) var wednesday: Bedtime?
    @Relationship(deleteRule: .cascade) var thursday: Bedtime?
    @Relationship(deleteRule: .cascade) var friday: Bedtime?
    @Relationship(deleteRule: .cascade) var saturday: Bedtime?
    @Relationship(deleteRule: .cascade) var sunday: Bedtime?
    
    init(name: String, isActive: Bool) {
        self.id = UUID()
        self.name = name
        self.isActive = isActive
    }
    
    func setBedtimes(monday: Bedtime, tuesday: Bedtime, wednesday: Bedtime, thursday: Bedtime, friday: Bedtime, saturday: Bedtime, sunday: Bedtime) {
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.sunday = sunday
    }
    
    func getBedtime(dayOfWeek: Date.DayOfTheWeek) -> Bedtime? {
        switch dayOfWeek {
        case .Sunday:
            return self.sunday
        case .Monday:
            return self.monday
        case .Tuesday:
            return self.tuesday
        case .Wednesday:
            return self.wednesday
        case .Thursday:
            return self.thursday
        case .Friday:
            return self.friday
        case .Saturday:
            return self.saturday
        }
    }
}
