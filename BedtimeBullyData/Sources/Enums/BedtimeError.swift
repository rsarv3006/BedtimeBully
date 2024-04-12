//
//  BedtimeError.swift
//  BedtimeBullyData
//
//  Created by Robert J. Sarvis Jr on 11/28/23.
//

import Foundation

public enum BedtimeError: Error {
    case failedToCreateBedtimeDate
    case notificationScheduleNotSetOnBedtime
    case noBedtimeSchedule
    case unableToGetBedtime
}
