//
//  Notifications.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/12/23.
//

import UserNotifications

public enum NotificationService {
    static let center = UNUserNotificationCenter.current()

    public static func requestAuthorization(completion: @escaping (Bool, (any Error)?) -> Void) {
        center.requestAuthorization(options: [.alert, .sound], completionHandler: completion)
    }

    public static func scheduleNotification(id: String, title: String, body: String, timestamp: Date) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: timestamp)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: id,
                                            content: content, trigger: trigger)

        center.add(request)

        return id
    }

    public static func cancelNotification(id: String) {
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }

    public static func debugGetAllNotifications() {
        center.getPendingNotificationRequests { requests in
            for request in requests {
                print(request.identifier)
                print(request.content.title)
            }
        }
    }
}
