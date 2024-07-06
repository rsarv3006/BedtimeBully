import UserNotifications

public enum NotificationService {
    static let center = UNUserNotificationCenter.current()

    public static func requestAuthorization(completion: @escaping (Bool, (any Error)?) -> Void) {
        center.requestAuthorization(options: [.badge, .sound, .alert, .carPlay], completionHandler: completion)
    }

    public static func scheduleNotification(id: String, title: String, body: String, timestamp: Date) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.interruptionLevel = .timeSensitive
        content.sound = UNNotificationSound.default

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: timestamp)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: id,
                                            content: content, trigger: trigger)

        if timestamp < Date() {
            return ""
        }

        center.add(request)

        return id
    }

    public static func cancelNotifications(ids: [String]) {
        if !ids.isEmpty {
            center.removePendingNotificationRequests(withIdentifiers: ids)
        }
    }

    public static func debugGetAllNotifications() {
        center.getPendingNotificationRequests { requests in
            for request in requests {
                print("\(request.identifier) - \(request.content.title) - \(request.content.body) - \(String(describing: request.trigger)) - \(request.content.interruptionLevel) - \(String(describing: request.content.sound))")
            }
        }
    }
}
