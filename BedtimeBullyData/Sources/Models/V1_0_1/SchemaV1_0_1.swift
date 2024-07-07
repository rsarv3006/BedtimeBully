import Foundation

#if canImport(SwiftData)
    import SwiftData
#endif

@available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
public enum SchemaV1_0_1: VersionedSchema {
    public static var models: [any PersistentModel.Type] = [
        Bedtime.self,
        BedtimeScheduleTemplate.self,
        Config.self,
        NotificationSchedule.self,
        BedtimeHistory.self,
    ]

    public static var versionIdentifier: Schema.Version = .init(1, 0, 2)
}
