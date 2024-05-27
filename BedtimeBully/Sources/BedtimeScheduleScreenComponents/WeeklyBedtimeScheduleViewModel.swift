import BedtimeBullyData
import SwiftData
import SwiftUI

public class WeeklyBedtimeScheduleViewModel: ObservableObject {
    @Published private var bedtimeSchedule: BedtimeScheduleTemplate

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

    public init(schedule: BedtimeScheduleTemplate) {
        bedtimeSchedule = schedule
        let now = Date()

        if let sundayBuiltDate = try? schedule.sunday?.toDate(baseDate: now) {
            sundayBedtime = sundayBuiltDate
            isSundayEnabled = true
        } else {
            isSundayEnabled = false
            sundayBedtime = now
        }

        if let mondayBuiltDate = try? schedule.monday?.toDate(baseDate: now) {
            mondayBedtime = mondayBuiltDate
            isMondayEnabled = true
        } else {
            mondayBedtime = now
            isMondayEnabled = false
        }

        if let tuesdayBuiltDate = try? schedule.tuesday?.toDate(baseDate: now) {
            tuesdayBedtime = tuesdayBuiltDate
            isTuesdayEnabled = true
        } else {
            tuesdayBedtime = now
            isTuesdayEnabled = false
        }

        if let wednesdayBuiltDate = try? schedule.wednesday?.toDate(baseDate: now) {
            wednesdayBedtime = wednesdayBuiltDate
            isWednesdayEnabled = true
        } else {
            wednesdayBedtime = now
            isWednesdayEnabled = false
        }

        if let thursdayBuiltDate = try? schedule.thursday?.toDate(baseDate: now) {
            thursdayBedtime = thursdayBuiltDate
            isThursdayEnabled = true
        } else {
            thursdayBedtime = now
            isThursdayEnabled = false
        }

        if let fridayBuiltDate = try? schedule.friday?.toDate(baseDate: now) {
            fridayBedtime = fridayBuiltDate
            isFridayEnabled = true
        } else {
            fridayBedtime = now
            isFridayEnabled = false
        }

        if let saturdayBuiltDate = try? schedule.saturday?.toDate(baseDate: now) {
            saturdayBedtime = saturdayBuiltDate
            isSaturdayEnabled = true
        } else {
            saturdayBedtime = now
            isSaturdayEnabled = false
        }
    }

    func saveBedtimeSchedule(_ modelContext: ModelContext) {
        let mondayTime = isMondayEnabled ? try? mondayBedtime.getTime() : nil
        let tuesdayTime = isTuesdayEnabled ? try? tuesdayBedtime.getTime() : nil
        let wednesdayTime = isWednesdayEnabled ? try? wednesdayBedtime.getTime() : nil
        let thursdayTime = isThursdayEnabled ? try? thursdayBedtime.getTime() : nil
        let fridayTime = isFridayEnabled ? try? fridayBedtime.getTime() : nil
        let saturdayTime = isSaturdayEnabled ? try? saturdayBedtime.getTime() : nil
        let sundayTime = isSundayEnabled ? try? sundayBedtime.getTime() : nil

        do {
            hasError = false
            errorUpdatingBedtimeSchedule = ""
            try bedtimeSchedule.setBedtimes(
                modelContext: modelContext,
                monday: mondayTime,
                tuesday: tuesdayTime,
                wednesday: wednesdayTime,
                thursday: thursdayTime,
                friday: fridayTime,
                saturday: saturdayTime,
                sunday: sundayTime
            )

            try updateNotificationsfromUpdatedBedtimeSchedule(modelContext: modelContext, newBedtimeSchedule: bedtimeSchedule)
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
