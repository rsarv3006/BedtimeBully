import Foundation
import SwiftData

@Model
public class NotificationItem {
    public let id: TimeInterval
    public let message: String
    
    public init(id: TimeInterval, message: String) {
        self.id = id
        self.message = message
    }
}
