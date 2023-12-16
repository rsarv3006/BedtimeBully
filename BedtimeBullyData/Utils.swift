//
//  Utils.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/23/23.
//

import Foundation

struct DataUtils {
    
    static func calculateNotificationTime(bedtime: Date, notificationOffset: TimeInterval) -> Date {
        return bedtime.addingTimeInterval(-notificationOffset)
    }
}
