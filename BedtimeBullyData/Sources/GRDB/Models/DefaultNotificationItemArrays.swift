import Foundation

public enum NotificationMessageType: String, CaseIterable {
    case Standard
    case Aggressive
    case Aussie
}

public let DefaultNotificationItems: [NotificationItem] = [
    NotificationItem(id: TimeInterval(30 * 60), message: "Bedtime in 30 minutes"),
    NotificationItem(id: TimeInterval(15 * 60), message: "Bedtime in 15 minutes"),
    NotificationItem(id: TimeInterval(10 * 60), message: "Bedtime in 10 minutes"),
    NotificationItem(id: TimeInterval(5 * 60), message: "Bedtime in 5 minutes"),
    NotificationItem(id: TimeInterval(3 * 60), message: "Bedtime in 3 minutes"),
    NotificationItem(id: TimeInterval(2 * 60), message: "Bedtime in 2 minutes"),
    NotificationItem(id: TimeInterval(1 * 60), message: "Bedtime in 1 minute"),
    NotificationItem(id: TimeInterval(-1), message: "Time for Bed!"),
]

public let AggressiveNotificationItems: [NotificationItem] = [
    NotificationItem(id: TimeInterval(30 * 60), message: "30 minutes left. Start wrapping things up, sleepyhead!"),
    NotificationItem(id: TimeInterval(15 * 60), message: "15 minutes to go. No excuses, bedtime's coming!"),
    NotificationItem(id: TimeInterval(10 * 60), message: "10 minutes! Drop what you're doing and get ready for bed."),
    NotificationItem(id: TimeInterval(5 * 60), message: "5 minutes left. Seriously, start moving towards your bed."),
    NotificationItem(id: TimeInterval(3 * 60), message: "3 minutes! You better be in your pajamas by now."),
    NotificationItem(id: TimeInterval(2 * 60), message: "2 minutes remaining. Last chance to brush your teeth!"),
    NotificationItem(id: TimeInterval(1 * 60), message: "1 minute! If you're not in bed, you're in trouble."),
    NotificationItem(id: TimeInterval(-1), message: "Lights out NOW! No more messing around!"),
]

public let AussieNotificationItems: [NotificationItem] = [
    NotificationItem(id: TimeInterval(30 * 60), message: "Oi! 30 minutes 'til beddy-byes, ya drongo!"),
    NotificationItem(id: TimeInterval(15 * 60), message: "Fair dinkum, only 15 minutes left. Time to hit the sack soon!"),
    NotificationItem(id: TimeInterval(10 * 60), message: "10 minutes, mate! Don't chuck a wobbly, just get ready for bed."),
    NotificationItem(id: TimeInterval(5 * 60), message: "5 minutes to go! Stop mucking about and get to ya room!"),
    NotificationItem(id: TimeInterval(3 * 60), message: "3 minutes left, ya galah! Better be in ya jammies!"),
    NotificationItem(id: TimeInterval(2 * 60), message: "2 minutes! Hurry up, or I'll chuck a spaz!"),
    NotificationItem(id: TimeInterval(1 * 60), message: "1 minute! Get to bed now or I'll tell ya mum!"),
    NotificationItem(id: TimeInterval(-1), message: "Righto, it's bedtime! Off to Bedfordshire with ya, no worries!"),
]
