import Foundation

#if canImport(SwiftData)
import SwiftData
#endif

@available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
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
