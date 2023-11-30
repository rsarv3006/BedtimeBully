//
//  BedtimeSchedule.swift
//  BedtimeBullyData
//
//  Created by Robert J. Sarvis Jr on 11/28/23.
//

import Foundation
import SwiftData

@Model
class BedtimeSchedule {
    let id: UUID
    let name: String
    let isActive: Bool
    
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
}
