import Foundation
import GRDB

#if canImport(SwiftData) 
import SwiftData
#endif

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
                    notificationScheduleId: notificationSchedule.id
                )

                try scheduleTemplate.insert(db)
            }
        }
    }

    func getActiveScheduleTemplate() throws -> GRDBScheduleTemplate? {
        return try dbWriter.read { db in
            try GRDBScheduleTemplate.all().filter(GRDBScheduleTemplate.Columns.isActive == true).fetchOne(db)
        }
    }

    func updateBedtimeAndNotifications(newBedtime: Date) throws {
        let bedtimeTime = try newBedtime.getTime()
        let newBedtimeItem = ScheduleTemplateDayItem(time: bedtimeTime, isEnabled: true)

        let bedtimeSchedule = try getActiveScheduleTemplate()

        guard var bedtimeSchedule else {
            throw BedtimeError.noActiveScheduleTemplate
        }

        try removeAllBedtimesAndNotifications()

        try dbWriter.write { db in
            try bedtimeSchedule.setBedtimes(db: db,
                                            monday: newBedtimeItem,
                                            tuesday: newBedtimeItem,
                                            wednesday: newBedtimeItem,
                                            thursday: newBedtimeItem,
                                            friday: newBedtimeItem,
                                            saturday: newBedtimeItem,
                                            sunday: newBedtimeItem)
        }
        try addBedtimesFromSchedule()
    }

    func updateWeeklyBedtimeSchedule(
        bedtimeSchedule: GRDBScheduleTemplate,
        monday: ScheduleTemplateDayItem,
        tuesday: ScheduleTemplateDayItem,
        wednesday: ScheduleTemplateDayItem,
        thursday: ScheduleTemplateDayItem,
        friday: ScheduleTemplateDayItem,
        saturday: ScheduleTemplateDayItem,
        sunday: ScheduleTemplateDayItem
    ) throws {
        var bedtimeSchedule = bedtimeSchedule
        try dbWriter.write {
            db in
            try bedtimeSchedule.setBedtimes(
                db: db,
                monday: monday,
                tuesday: tuesday,
                wednesday: wednesday,
                thursday: thursday,
                friday: friday,
                saturday: saturday,
                sunday: sunday
            )
        }

        try removeAllBedtimesAndNotifications()

        try addBedtimesFromSchedule()
    }

    @available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
    func updateScheduleFromSwiftData(_ modelContext: ModelContext) throws {
        let grdbScheduleTemplate = try getActiveScheduleTemplate()
        guard var grdbScheduleTemplate else {
            throw BedtimeError.noActiveScheduleTemplate
        }

        // TODO: Finish migriation from SwiftData to GRDB
    }
}
