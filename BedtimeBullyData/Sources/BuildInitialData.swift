//
//  BuildInitialData.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/26/23.
//

import Foundation
import Notifications
import SwiftData

public func buildInitialData(_ modelContext: ModelContext) throws {
    let schedulesFetchDescriptor: FetchDescriptor<NotificationSchedule> = FetchDescriptor()
    let schedules = try modelContext.fetch(schedulesFetchDescriptor)

    if schedules.count == 0 {
        print("creating default schedule")
        let defaultSchedule = NotificationSchedule(name: "Default", notificationIntervals: [
            TimeInterval(30 * 60),
            TimeInterval(15 * 60),
            TimeInterval(10 * 60),
            TimeInterval(5 * 60),
            TimeInterval(3 * 60),
            TimeInterval(2 * 60),
            TimeInterval(1 * 60),
            TimeInterval(1 * 01),
            TimeInterval(0.5 * 60),
        ], notificationMessages: [
            "Bedtime in 30 minutes",
            "Bedtime in 15 minutes",
            "Bedtime in 10 minutes",
            "Bedtime in 5 minutes",
            "Bedtime in 3 minutes",
            "Bedtime in 2 minutes",
            "Bedtime in 1 minute",
            "Time for Bed!",
            "Bedtime in 30 seconds",
        ])
        modelContext.insert(defaultSchedule)

        print("default schedule has been created - creating default bedtimes")
        let defaultBedtime = try! Time(hour: 21, minute: 45)

        print("default bed times created")

        let defaultBedtimeScheduleTemplate = BedtimeScheduleTemplate(name: "Default Bedtime Schedule", isActive: true)

        print("default bedtime schedule created")
        defaultBedtimeScheduleTemplate.setBedtimes(monday: defaultBedtime, tuesday: defaultBedtime, wednesday: defaultBedtime, thursday: defaultBedtime, friday: defaultBedtime, saturday: defaultBedtime, sunday: defaultBedtime)
        print("default bedtimes set")
        defaultBedtimeScheduleTemplate.notificationSchedule = defaultSchedule

        modelContext.insert(defaultBedtimeScheduleTemplate)

        let config = Config.createConfig()
        modelContext.insert(config)
    }
}

public func addBedtimesFromSchedule(_ modelContext: ModelContext) throws {
    let bedtimeScheduleTemplatesDescriptor: FetchDescriptor<BedtimeScheduleTemplate> = FetchDescriptor()
    let scheduleTemplates = try modelContext.fetch(bedtimeScheduleTemplatesDescriptor)

    let activeScheduleTemplate = scheduleTemplates.first { $0.isActive == true }

    if let activeScheduleTemplate = activeScheduleTemplate {
        let bedtimesFetchDescriptor: FetchDescriptor<Bedtime> = FetchDescriptor(
            predicate: #Predicate { $0.isActive == true },
            sortBy: [
                .init(\.id),
            ]
        )
        let bedtimes = try modelContext.fetch(bedtimesFetchDescriptor)

        if bedtimes.count < 7 {
            let now = Date()
            let calendar = Calendar.current
            let todayDayOfWeek = calendar.component(.weekday, from: now)

            for index in todayDayOfWeek ... 7 {
                let timeForBedtime = activeScheduleTemplate.getBedtime(dayOfWeek: index)
                let dateSection = calendar.date(byAdding: .day, value: index - 1, to: now)

                if let timeForBedtime, let dateSection {
                    let bedtimeDate = calendar.date(bySettingHour: timeForBedtime.hour, minute: timeForBedtime.minute, second: 0, of: dateSection)

                    if let bedtimeDate, bedtimes.first(where: { $0.id == bedtimeDate.timeIntervalSince1970 }) == nil {
                        let notificationSchedule = activeScheduleTemplate.notificationSchedule

                        try createBedtimeAndNotificationsforDate(modelContext: modelContext, bedtimeDate: bedtimeDate, notificationSchedule: notificationSchedule)
                    }
                }
            }
        }
    }
}

func createBedtimeAndNotificationsforDate(modelContext: ModelContext, bedtimeDate: Date, notificationSchedule: NotificationSchedule?) throws {
    let bedtime = Bedtime(date: bedtimeDate, name: "Bedtime I guess what is this even for?", isActive: true)

    let notificationDates = try bedtime.generateNotificationDates(notificationSchedule: notificationSchedule)
    var notificationItems: [NotificationItem] = []

    for index in 0 ..< notificationDates.count {
        let notificationDate = notificationDates[index]
        let notifcationItem = NotificationItem(id: TimeInterval(notificationDate.timeIntervalSince1970), message: notificationSchedule?.notificationMessages[index] ?? "")
        notificationItems.append(notifcationItem)
        modelContext.insert(notifcationItem)
    }

    bedtime.notificationItems = notificationItems
}

public func addNotificationsForAllActiveBedtimes(modelContext: ModelContext) throws {
    let bedtimesFetchDescriptor: FetchDescriptor<Bedtime> = FetchDescriptor(
        predicate: #Predicate { $0.isActive == true },
        sortBy: [
            .init(\.id),
        ]
    )
    let bedtimes = try modelContext.fetch(bedtimesFetchDescriptor)

    for bedtime in bedtimes {
        bedtime.notificationItems?.forEach(
        ) { notificationItem in
            print("\(notificationItem.id) - \(notificationItem.message)")
            let date = Date(timeIntervalSince1970: notificationItem.id)
            _ = NotificationService.scheduleNotification(id: String("\(notificationItem.id)"), title: "Bedtime Bully", body: notificationItem.message, timestamp: date)
        }
    }
}

public func wipeAllData(modelContext: ModelContext) throws {
    print("WIPING ALL DATA")
    let bedtimesFetchDescriptor: FetchDescriptor<Bedtime> = FetchDescriptor()
    let bedtimes = try modelContext.fetch(bedtimesFetchDescriptor)

    for bedtime in bedtimes {
        modelContext.delete(bedtime)
    }

    let notificationItemsFetchDescriptor: FetchDescriptor<NotificationItem> = FetchDescriptor()
    let notificationItems = try modelContext.fetch(notificationItemsFetchDescriptor)

    for notificationItem in notificationItems {
        modelContext.delete(notificationItem)
    }

    let schedulesFetchDescriptor: FetchDescriptor<NotificationSchedule> = FetchDescriptor()
    let schedules = try modelContext.fetch(schedulesFetchDescriptor)

    for schedule in schedules {
        modelContext.delete(schedule)
    }

    let bedtimeScheduleTemplatesDescriptor: FetchDescriptor<BedtimeScheduleTemplate> = FetchDescriptor()
    let scheduleTemplates = try modelContext.fetch(bedtimeScheduleTemplatesDescriptor)

    for scheduleTemplate in scheduleTemplates {
        modelContext.delete(scheduleTemplate)
    }
}
