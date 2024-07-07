import Foundation

public struct DataUtils {

    public static func calculateNotificationTime(bedtime: Date, notificationOffset: TimeInterval) -> Date {
        return bedtime.addingTimeInterval(-notificationOffset)
    }

    @available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
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
