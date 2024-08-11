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
                    notifSchedule.status == .active
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

        let bedtimeScheduleTemplateFetchDescriptor = FetchDescriptor<SchemaV1_0_1.BedtimeScheduleTemplate>()

        let swiftDataScheduleTemplates = try modelContext.fetch(bedtimeScheduleTemplateFetchDescriptor)

        let defaultBedtimeTime = try Time(hour: 21, minute: 45)

        guard let swiftDataScheduleTemplate = swiftDataScheduleTemplates.first else { return }

        let mondayTime = swiftDataScheduleTemplate.monday ?? defaultBedtimeTime
        let isMondayEnabled = swiftDataScheduleTemplate.monday != nil
        grdbScheduleTemplate.monday = ScheduleTemplateDayItem(time: mondayTime, isEnabled: isMondayEnabled)

        let tuesdayTime = swiftDataScheduleTemplate.tuesday ?? defaultBedtimeTime
        let isTuesdayEnabled = swiftDataScheduleTemplate.tuesday != nil
        grdbScheduleTemplate.tuesday = ScheduleTemplateDayItem(time: tuesdayTime, isEnabled: isTuesdayEnabled)

        let wednesdayTime = swiftDataScheduleTemplate.wednesday ?? defaultBedtimeTime
        let isWednesdayEnabled = swiftDataScheduleTemplate.wednesday != nil
        grdbScheduleTemplate.wednesday = ScheduleTemplateDayItem(time: wednesdayTime, isEnabled: isWednesdayEnabled)

        let thursdayTime = swiftDataScheduleTemplate.thursday ?? defaultBedtimeTime
        let isThursdayEnabled = swiftDataScheduleTemplate.thursday != nil
        grdbScheduleTemplate.thursday = ScheduleTemplateDayItem(time: thursdayTime, isEnabled: isThursdayEnabled)

        let fridayTime = swiftDataScheduleTemplate.friday ?? defaultBedtimeTime
        let isFridayEnabled = swiftDataScheduleTemplate.friday != nil
        grdbScheduleTemplate.friday = ScheduleTemplateDayItem(time: fridayTime, isEnabled: isFridayEnabled)

        let saturdayTime = swiftDataScheduleTemplate.saturday ?? defaultBedtimeTime
        let isSaturdayEnabled = swiftDataScheduleTemplate.saturday != nil
        grdbScheduleTemplate.saturday = ScheduleTemplateDayItem(time: saturdayTime, isEnabled: isSaturdayEnabled)

        let sundayTime = swiftDataScheduleTemplate.sunday ?? defaultBedtimeTime
        let isSundayEnabled = swiftDataScheduleTemplate.sunday != nil
        grdbScheduleTemplate.sunday = ScheduleTemplateDayItem(time: sundayTime, isEnabled: isSundayEnabled)

        try dbWriter.write { db in
            try grdbScheduleTemplate.update(db)
        }

        modelContext.delete(swiftDataScheduleTemplate)
    }
}
