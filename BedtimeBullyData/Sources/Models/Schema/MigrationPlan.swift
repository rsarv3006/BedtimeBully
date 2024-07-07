import Foundation

#if canImport(SwiftData)
    import SwiftData
#endif

@available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
public struct MigrationPlan: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] = [
        SchemaV1.self,
        SchemaV1_0_1.self,
    ]

    public static var stages: [MigrationStage] = [migrateV1ToV1_0_1]

    static let migrateV1ToV1_0_1: MigrationStage = .lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV1_0_1.self)
}
