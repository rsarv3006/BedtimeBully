import Foundation

public class NotificationItem: Codable, Hashable {
    public static func == (lhs: NotificationItem, rhs: NotificationItem) -> Bool {
        return "\(lhs.id)-\(lhs.message)" == "\(rhs.id)-\(rhs.message)"
    }
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self))
    }
    
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
