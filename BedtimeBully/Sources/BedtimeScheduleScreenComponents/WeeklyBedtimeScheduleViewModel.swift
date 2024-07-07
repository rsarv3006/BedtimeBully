import BedtimeBullyData
import GRDB
import SwiftUI

public class WeeklyBedtimeScheduleViewModel: ObservableObject {
    @Published private var bedtimeSchedule: GRDBScheduleTemplate

    @Published var isSundayEnabled: Bool
    @Published var sundayBedtime: Date

    @Published var isMondayEnabled: Bool
    @Published var mondayBedtime: Date

    @Published var isTuesdayEnabled: Bool
    @Published var tuesdayBedtime: Date

    @Published var isWednesdayEnabled: Bool
    @Published var wednesdayBedtime: Date

    @Published var isThursdayEnabled: Bool
    @Published var thursdayBedtime: Date

    @Published var isFridayEnabled: Bool
    @Published var fridayBedtime: Date

    @Published var isSaturdayEnabled: Bool
    @Published var saturdayBedtime: Date

    @Published var hasError = false
    @Published var errorUpdatingBedtimeSchedule = ""
    @Published var showBedtimeHasUpdated = false

    public init(schedule: GRDBScheduleTemplate) {
        bedtimeSchedule = schedule
        let now = Date()

        if let sundayBuiltDate = try? schedule.sunday.time.toDate(baseDate: now) {
            sundayBedtime = sundayBuiltDate
            isSundayEnabled = schedule.sunday.isEnabled
        } else {
            sundayBedtime = now
            isSundayEnabled = false
        }

        if let mondayBuiltDate = try? schedule.monday.time.toDate(baseDate: now) {
            mondayBedtime = mondayBuiltDate
            isMondayEnabled = schedule.monday.isEnabled
        } else {
            mondayBedtime = now
            isMondayEnabled = false
        }

        if let tuesdayBuiltDate = try? schedule.tuesday.time.toDate(baseDate: now) {
            tuesdayBedtime = tuesdayBuiltDate
            isTuesdayEnabled = schedule.tuesday.isEnabled
        } else {
            tuesdayBedtime = now
            isTuesdayEnabled = false
        }

        if let wednesdayBuiltDate = try? schedule.wednesday.time.toDate(baseDate: now) {
            wednesdayBedtime = wednesdayBuiltDate
            isWednesdayEnabled = schedule.wednesday.isEnabled
        } else {
            wednesdayBedtime = now
            isWednesdayEnabled = false
        }

        if let thursdayBuiltDate = try? schedule.thursday.time.toDate(baseDate: now) {
            thursdayBedtime = thursdayBuiltDate
            isThursdayEnabled = schedule.thursday.isEnabled
        } else {
            thursdayBedtime = now
            isThursdayEnabled = false
        }

        if let fridayBuiltDate = try? schedule.friday.time.toDate(baseDate: now) {
            fridayBedtime = fridayBuiltDate
            isFridayEnabled = schedule.friday.isEnabled
        } else {
            fridayBedtime = now
            isFridayEnabled = false
        }

        if let saturdayBuiltDate = try? schedule.saturday.time.toDate(baseDate: now) {
            saturdayBedtime = saturdayBuiltDate
            isSaturdayEnabled = schedule.saturday.isEnabled
        } else {
            saturdayBedtime = now
            isSaturdayEnabled = false
        }
    }

    func saveBedtimeSchedule(_ appDatabase: AppDatabase) {
        do {
            let monday = ScheduleTemplateDayItem(time: try mondayBedtime.getTime(), isEnabled: isMondayEnabled)
            let tuesday = ScheduleTemplateDayItem(time: try tuesdayBedtime.getTime(), isEnabled: isTuesdayEnabled)
            let wednesday = ScheduleTemplateDayItem(time: try wednesdayBedtime.getTime(), isEnabled: isWednesdayEnabled)
            let thursday = ScheduleTemplateDayItem(time: try thursdayBedtime.getTime(), isEnabled: isThursdayEnabled)
            let friday = ScheduleTemplateDayItem(time: try fridayBedtime.getTime(), isEnabled: isFridayEnabled)
            let saturday = ScheduleTemplateDayItem(time: try saturdayBedtime.getTime(), isEnabled: isSaturdayEnabled)
            let sunday = ScheduleTemplateDayItem(time: try sundayBedtime.getTime(), isEnabled: isSundayEnabled)

            hasError = false
            errorUpdatingBedtimeSchedule = ""
            try appDatabase.updateWeeklyBedtimeSchedule(
                bedtimeSchedule: bedtimeSchedule,
                monday: monday,
                tuesday: tuesday,
                wednesday: wednesday,
                thursday: thursday,
                friday: friday,
                saturday: saturday,
                sunday: sunday
            )

            showBedtimeHasUpdated = true

        } catch {
            errorUpdatingBedtimeSchedule = error.localizedDescription
            hasError = true
        }
    }

    func debugString() -> String {
        var strReturn = "Monday: \(bedtimeSchedule.monday.debugDescription)"
        strReturn += "\nTuesday: \(bedtimeSchedule.tuesday.debugDescription)"
        strReturn += "\nWednesday: \(bedtimeSchedule.wednesday.debugDescription)"
        strReturn += "\nThursday: \(bedtimeSchedule.thursday.debugDescription)"
        strReturn += "\nFriday: \(bedtimeSchedule.friday.debugDescription)"
        strReturn += "\nSaturday: \(bedtimeSchedule.saturday.debugDescription)"
        strReturn += "\nSunday: \(bedtimeSchedule.sunday.debugDescription)"
        return strReturn
    }
}
