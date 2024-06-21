import Foundation

public enum BedtimeError: Error, LocalizedError {
    case failedToCreateBedtimeDate
    case notificationScheduleNotSetOnBedtime
    case noBedtimeSchedule
    case unableToGetBedtime
    case noActiveScheduleTemplate
    case unableToCreateNotificationSchedule
    
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
        case .noActiveScheduleTemplate:
            return "No active schedule template"
        case .unableToCreateNotificationSchedule:
            return "Uable to create a notificationSchedule"
        }
    }
}
