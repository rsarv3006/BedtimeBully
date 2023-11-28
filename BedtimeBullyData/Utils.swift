//
//  Utils.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/23/23.
//

import Foundation

struct DataUtils {
    static func calculateTimeUntilBedtime(currentTime: Date, bedtime: Date) -> (hours: Int, minutes: Int, seconds: Int) {
        let calendar = Calendar.current
        
        let diffComponents = calendar.dateComponents([.hour, .minute, .second], from: currentTime, to: bedtime)
        
        let hours = diffComponents.hour ?? 0
        let minutes = diffComponents.minute ?? 0
        let seconds = diffComponents.second ?? 0
        
        return (hours, minutes, seconds)
    }
    
    static func calculateFirstNotificationTime(bedtime: Date, notificationOffset: TimeInterval) -> Date {
        return bedtime.addingTimeInterval(-notificationOffset)
    }
}
