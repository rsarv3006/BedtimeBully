import Foundation

#if canImport(SwiftData)
import SwiftData
#endif

@available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
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
