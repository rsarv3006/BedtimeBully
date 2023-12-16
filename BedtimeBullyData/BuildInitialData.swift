//
//  GenerateInitialValues.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/26/23.
//

import Foundation
import SwiftData

func buildInitialData(_ modelContext: ModelContext) throws {
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
            TimeInterval(0.5 * 60),
            TimeInterval(0 * 60),
        ])
        modelContext.insert(defaultSchedule)
        
        print("default schedule has been created - creating default bedtimes")
        let defaultBedtime = try! Time(hour: 21, minute: 45) 
        
        let defaultMondayBedtime = Bedtime(name: "Monday Default", bedtimeDay: .monday, isActive: true, bedtime: defaultBedtime)
        let defaultTuesdayBedtime = Bedtime(name: "Tuesday Default", bedtimeDay: .monday, isActive: true, bedtime: defaultBedtime)
        let defaultWednesdayBedtime = Bedtime(name: "Wednesday Default", bedtimeDay: .monday, isActive: true, bedtime: defaultBedtime)
        let defaultThursdayBedtime = Bedtime(name: "Thursday Default", bedtimeDay: .monday, isActive: true, bedtime: defaultBedtime)
        let defaultFridayBedtime = Bedtime(name: "Friday Default", bedtimeDay: .monday, isActive: true, bedtime: defaultBedtime)
        let defaultSaturdayBedtime = Bedtime(name: "Saturday Default", bedtimeDay: .monday, isActive: true, bedtime: defaultBedtime)
        let defaultSundayBedtime = Bedtime(name: "Sunday Default", bedtimeDay: .monday, isActive: true, bedtime: defaultBedtime)
        
        defaultMondayBedtime.addNotificationSchedule(notificationSchedule: defaultSchedule)
        defaultTuesdayBedtime.addNotificationSchedule(notificationSchedule: defaultSchedule)
        defaultWednesdayBedtime.addNotificationSchedule(notificationSchedule: defaultSchedule)
        defaultThursdayBedtime.addNotificationSchedule(notificationSchedule: defaultSchedule)
        defaultFridayBedtime.addNotificationSchedule(notificationSchedule: defaultSchedule)
        defaultSaturdayBedtime.addNotificationSchedule(notificationSchedule: defaultSchedule)
        defaultSundayBedtime.addNotificationSchedule(notificationSchedule: defaultSchedule)
       
        modelContext.insert(defaultMondayBedtime)
        modelContext.insert(defaultTuesdayBedtime)
        modelContext.insert(defaultWednesdayBedtime)
        modelContext.insert(defaultThursdayBedtime)
        modelContext.insert(defaultFridayBedtime)
        modelContext.insert(defaultSaturdayBedtime)
        modelContext.insert(defaultSundayBedtime)
        
        print("default bed times created")
        
        let defaultBedtimeSchedule = BedtimeSchedule(name: "Default Bedtime Schedule", isActive: true)
        print("default bedtime schedule created")
        defaultBedtimeSchedule.setBedtimes(monday: defaultMondayBedtime, tuesday: defaultTuesdayBedtime, wednesday: defaultWednesdayBedtime, thursday: defaultThursdayBedtime, friday: defaultFridayBedtime, saturday: defaultSaturdayBedtime, sunday: defaultSundayBedtime)
        print("default bedtimes set")
        
        modelContext.insert(defaultBedtimeSchedule)
    }
    
    
}
