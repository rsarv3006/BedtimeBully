import Foundation
import SwiftData

public struct MigrationPlan: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] = [
        SchemaV1.self,
        SchemaV1_0_1.self
    ]
    
    public static var stages: [MigrationStage] = [migrateV1ToV1_0_1]
    
    static let migrateV1ToV1_0_1: MigrationStage = MigrationStage.lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV1_0_1.self)
}
