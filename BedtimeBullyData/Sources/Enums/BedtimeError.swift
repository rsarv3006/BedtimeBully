//
//  BedtimeError.swift
//  BedtimeBullyData
//
//  Created by Robert J. Sarvis Jr on 11/28/23.
//

import Foundation

public enum BedtimeError: Error, LocalizedError {
    case failedToCreateBedtimeDate
    case notificationScheduleNotSetOnBedtime
    case noBedtimeSchedule
    case unableToGetBedtime
    
    public var errorDescription: String? {
        switch self {
        case .failedToCreateBedtimeDate:
            return "Failed to create bedtime date"
        case .notificationScheduleNotSetOnBedtime:
            return "Notification schedule not set on bedtime"
        case .noBedtimeSchedule:
            return "No bedtime schedule"
        case .unableToGetBedtime:
            return "Unable to get bedtime"
        }
    }
}
