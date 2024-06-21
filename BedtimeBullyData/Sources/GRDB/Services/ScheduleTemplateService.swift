import Foundation
import GRDB

public extension AppDatabase {
    func createDefaultScheduleTemplate() throws {
        try dbWriter.write { db in
            if try GRDBScheduleTemplate.all().isEmpty(db) {
                let notificationSchedules = try GRDBNotificationSchedule.all().fetchAll(db)
                
                let defaultBedtimeTime = try Time(hour: 21, minute: 45)
                
                let defaultBedtime = ScheduleTemplateDayItem(time: defaultBedtimeTime, isEnabled: true)
                
                guard let notificationSchedule = notificationSchedules.first(where: { notifSchedule in
                    notifSchedule.name == "Default"
                }) else {
                    throw BedtimeError.failedToCreateBedtimeDate
                }
                
                let scheduleTemplate = GRDBScheduleTemplate.new(
                    name: "Default",
                    monday: defaultBedtime,
                    tuesday: defaultBedtime,
                    wednesday: defaultBedtime,
                    thursday: defaultBedtime,
                    friday: defaultBedtime,
                    saturday: defaultBedtime,
                    sunday: defaultBedtime,
                    notificationScheduleId: notificationSchedule.id)
                
                try scheduleTemplate.insert(db)
            }
        }
    }
}

