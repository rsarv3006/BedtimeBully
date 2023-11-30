//
//  NotificationSchedule.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/26/23.
//

import Foundation
import SwiftData

@Model
class NotificationSchedule {
    let id: UUID
    let name: String
    let notificationIntervals: [TimeInterval]
    
    init(name: String, notificationIntervals: [TimeInterval]) {
        self.id = UUID()
        self.name = name
        self.notificationIntervals = notificationIntervals
    }
}
