//
//  NotificationScheduleView.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/27/23.
//

import SwiftUI
import BedtimeBullyData

struct NotificationScheduleView: View {
    
    let schedule: NotificationSchedule?
    
    var body: some View {
        VStack {
            if let schedule {
                ForEach(schedule.notificationIntervals, id: \.self) { interval in
                    HStack {
                        Text("Notify \(interval.formatted()) prior")
                    }
                }
            } else {
                Text("No schedule selected")
            }
        }
    }
}

#Preview {
    NotificationScheduleView(schedule: NotificationSchedule(name: "Test", notificationIntervals: [60, 120, 180]))
}
