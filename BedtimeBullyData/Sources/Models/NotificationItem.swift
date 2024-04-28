import Foundation

public class NotificationItem: Codable {
    public let id: TimeInterval
    public let message: String
    
    public init(id: TimeInterval, message: String) {
        self.id = id
        self.message = message
    }
    
    public func idToString() -> String {
        return "\(id)"
    }
}
