import Foundation
import SwiftData

public enum SchemaV1: VersionedSchema {
    public static var models: [any PersistentModel.Type] = [
        Bedtime.self,
        BedtimeScheduleTemplate.self,
        Config.self,
        NotificationSchedule.self
    ]
    
    public static var versionIdentifier: Schema.Version = .init(1, 0, 0)
}
