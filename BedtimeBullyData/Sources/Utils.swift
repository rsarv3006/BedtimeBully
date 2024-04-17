//
//  Utils.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/23/23.
//

import Foundation

public struct DataUtils {

    public static func calculateNotificationTime(bedtime: Date, notificationOffset: TimeInterval) -> Date {
        return bedtime.addingTimeInterval(-notificationOffset)
    }

    public static func getBedtimeDateFromSchedule(_ bedtimeSchedule: BedtimeScheduleTemplate?) throws -> Date {
        guard let bedtimeSchedule = bedtimeSchedule else { throw BedtimeError.noBedtimeSchedule }
        let today = Date()
        let dayOfWeek = today.dayOfWeek

        if let bedtime = bedtimeSchedule.getBedtime(dayOfWeek: dayOfWeek) {

            let time = bedtime
            let bedtimeDate = try? time.toDate(baseDate: Date())

            if let todayBedtimeDate = bedtimeDate {
                if !todayBedtimeDate.isInPast {
                    return todayBedtimeDate
                } else {
                    if let tomorrowBedtimeDate = try? time.toDate(baseDate: Date.tomorrow) {
                        return tomorrowBedtimeDate
                    }
                }
            }
        }

        throw BedtimeError.unableToGetBedtime
    }
}
