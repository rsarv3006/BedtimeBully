//
//  NotificationSchedule.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/26/23.
//

import Foundation
import SwiftData

@Model
public class NotificationSchedule {
    public let id: UUID
    public let name: String
    public let notificationIntervals: [TimeInterval]
    
    public init(name: String, notificationIntervals: [TimeInterval]) {
        self.id = UUID()
        self.name = name
        self.notificationIntervals = notificationIntervals
    }
}
