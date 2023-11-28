//
//  GenerateInitialValues.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/26/23.
//

import Foundation
import SwiftData

func buildInitialData(_ modelContext: ModelContext) throws {
    // check if we have any data
    
    let fetchDescriptor: FetchDescriptor<NotificationSchedule> = FetchDescriptor()
    let schedules = try modelContext.fetch(fetchDescriptor)
    
    if schedules.count > 0 {
        print("schedules have been loaded")
        return
    } else {
        print("creating default schedule")
        let defaultSchedule = NotificationSchedule(name: "Default", notificationIntervals: [
            TimeInterval(30 * 60),
            TimeInterval(15 * 60),
            TimeInterval(10 * 60),
            TimeInterval(5 * 60),
            TimeInterval(3 * 60),
            TimeInterval(2 * 60),
            TimeInterval(1 * 60),
            TimeInterval(0.5 * 60),
            TimeInterval(0 * 60),
        ])
        modelContext.insert(defaultSchedule)
    }
    
    
}
