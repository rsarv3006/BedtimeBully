//
//  Notifications.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/12/23.
//

import UserNotifications

struct NotificationService {
    
    static let center = UNUserNotificationCenter.current()
    
    static func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound]) {granted, error in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
    }
    
    static func scheduleNotification(title: String, body: String, timestamp: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: timestamp)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content, trigger: trigger)
        
        center.add(request)
    }
}
