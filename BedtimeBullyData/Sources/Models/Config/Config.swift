import Foundation
import SwiftData
extension SchemaV1 {
    @Model
    public class Config {
        @Attribute(.unique) public let id: String
        public var isNotificationsEnabled: Bool
        public var hasSetBedtime: Bool
        
        public init(id: String, isNotificationsEnabled: Bool, hasSetBedtime: Bool) {
            self.id = id
            self.isNotificationsEnabled = isNotificationsEnabled
            self.hasSetBedtime = hasSetBedtime
        }
        
        public static func createConfig() -> Config {
            return Config(id: "config", isNotificationsEnabled: false, hasSetBedtime: false)
        }
    }
}
