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
        let defaultSchedule = NotificationSchedule(name: "Default", notificationIntervals: [
            TimeInterval(30 * 60),
            TimeInterval(15 * 60),
            TimeInterval(10 * 60),
            TimeInterval(5 * 60),
            TimeInterval(3 * 60),
            TimeInterval(2 * 60),
            TimeInterval(1 * 60),
            TimeInterval(-1),
        ], notificationMessages: [
            "Bedtime in 30 minutes",
            "Bedtime in 15 minutes",
            "Bedtime in 10 minutes",
            "Bedtime in 5 minutes",
            "Bedtime in 3 minutes",
            "Bedtime in 2 minutes",
            "Bedtime in 1 minute",
            "Time for Bed!",
        ])
        modelContext.insert(defaultSchedule)
        
        let defaultBedtime = try Time(hour: 21, minute: 45)
        
        let defaultBedtimeScheduleTemplate = BedtimeScheduleTemplate(name: "Default Bedtime Schedule", isActive: true)
        
        try defaultBedtimeScheduleTemplate.setBedtimes(modelContext: modelContext, monday: defaultBedtime, tuesday: defaultBedtime, wednesday: defaultBedtime, thursday: defaultBedtime, friday: defaultBedtime, saturday: defaultBedtime, sunday: defaultBedtime)
        
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
        let notificationSchedule = activeScheduleTemplate.notificationSchedule

        let bedtimesFetchDescriptor: FetchDescriptor<Bedtime> = FetchDescriptor(
            predicate: #Predicate { $0.isActive == true },
            sortBy: [
                .init(\.id),
            ]
        )
        let bedtimes = try modelContext.fetch(bedtimesFetchDescriptor)

        let now = Date()
        let calendar = Calendar.current
        let todayDayOfWeek = calendar.component(.weekday, from: now)

        for inc in 0 ..< 14 {
            let dayOfWeek = (todayDayOfWeek + inc - 1) % 7 + 1
            let timeForBedtime = activeScheduleTemplate.getBedtime(dayOfWeek: dayOfWeek)
            let dateSection = calendar.date(byAdding: .day, value: inc, to: now)

            if let timeForBedtime, let dateSection {
                let bedtimeDate = calendar.date(bySettingHour: timeForBedtime.hour, minute: timeForBedtime.minute, second: 0, of: dateSection)

                if let bedtimeDate, bedtimes.first(where: { $0.id == bedtimeDate.timeIntervalSince1970 }) == nil {

                    try createBedtimeAndNotificationsforDate(modelContext: modelContext, bedtimeDate: bedtimeDate, notificationSchedule: notificationSchedule)
                }
            }
        }
    }
}

func createBedtimeAndNotificationsforDate(modelContext: ModelContext, bedtimeDate: Date, notificationSchedule: NotificationSchedule?) throws {
    guard let notificationSchedule else {
        throw BedtimeError.notificationScheduleNotSetOnBedtime
    }
    let bedtime = try Bedtime(date: bedtimeDate, notificationSchedule: notificationSchedule)

    modelContext.insert(bedtime)
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
        bedtime.notificationItems.forEach(
        ) { notificationItem in
            let date = Date(timeIntervalSince1970: notificationItem.id)
            _ = NotificationService.scheduleNotification(id: notificationItem.idToString(), title: "Bedtime Bully", body: notificationItem.message, timestamp: date)
        }
    }
}

public func removeAllBedtimesAndNotifications(modelContext: ModelContext) throws {
    let bedtimesFetchDescriptor: FetchDescriptor<Bedtime> = FetchDescriptor()
    let bedtimes = try modelContext.fetch(bedtimesFetchDescriptor)
    
    var notificationItems: [NotificationItem] = []
    
    for bedtime in bedtimes {
        notificationItems.append(contentsOf: bedtime.notificationItems)
        modelContext.delete(bedtime)
    }
    
    let notificationItemIds = notificationItems.map { $0.idToString() }
    
    NotificationService.cancelNotifications(ids: notificationItemIds)
}

public func removeBedtimesAndNotificationsInThePast(modelContext: ModelContext, currentDate date: Date) throws {
    let bedtimesFetchDescriptor: FetchDescriptor<Bedtime> = FetchDescriptor(
        predicate: #Predicate { $0.id < date.timeIntervalSince1970 }
    )
    let bedtimes = try modelContext.fetch(bedtimesFetchDescriptor)
    
    var notificationItems: [NotificationItem] = []
    
    for bedtime in bedtimes {
        notificationItems.append(contentsOf: bedtime.notificationItems)
        modelContext.delete(bedtime)
    }
    
    let notificationItemIds = notificationItems.map { $0.idToString() }
    
    NotificationService.cancelNotifications(ids: notificationItemIds)
}

public func wipeAllData(modelContext: ModelContext) throws {
    let bedtimesFetchDescriptor: FetchDescriptor<Bedtime> = FetchDescriptor()
    let bedtimes = try modelContext.fetch(bedtimesFetchDescriptor)
    
    var notificationItems: [NotificationItem] = []
    
    for bedtime in bedtimes {
        notificationItems.append(contentsOf: bedtime.notificationItems)
        modelContext.delete(bedtime)
    }
    
    let notificationItemIds = notificationItems.map { $0.idToString() }
    
    NotificationService.cancelNotifications(ids: notificationItemIds)
    
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

public func updateBedtimeAndNotifications(modelContext: ModelContext, newBedtime: Date) throws {
    guard let bedtimeTime = newBedtime.getTime else { return }
    
    let bedtimeSchedulesFetchDescriptor: FetchDescriptor<BedtimeScheduleTemplate> = FetchDescriptor(
        predicate: BedtimeScheduleTemplate.activeBedtimeSchedulePredicate()
    )
    let bedtimeSchedules = try modelContext.fetch(bedtimeSchedulesFetchDescriptor)
    
    guard let bedtimeSchedule = bedtimeSchedules.first else { return }
    
    try removeAllBedtimesAndNotifications(modelContext: modelContext)
    
    try bedtimeSchedule.setBedtimes(modelContext: modelContext, monday: bedtimeTime, tuesday: bedtimeTime, wednesday: bedtimeTime, thursday: bedtimeTime, friday: bedtimeTime, saturday: bedtimeTime, sunday: bedtimeTime)
    
    try addBedtimesFromSchedule(modelContext)
    
    try addNotificationsForAllActiveBedtimes(modelContext: modelContext)
}
