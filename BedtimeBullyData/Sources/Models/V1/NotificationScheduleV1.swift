import Foundation
import SwiftData

extension SchemaV1 {
    @Model
    public class NotificationSchedule {
        public let id: UUID
        public let name: String
        public let notificationIntervals: [TimeInterval]
        public let notificationMessages: [String]
        
        public init(name: String, notificationIntervals: [TimeInterval], notificationMessages: [String]) {
            self.id = UUID()
            self.name = name
            self.notificationIntervals = notificationIntervals
            self.notificationMessages = notificationMessages
        }
    }
}
