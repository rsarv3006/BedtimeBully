import Foundation
import SwiftData

public struct MigrationPlan: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] = [
        SchemaV1.self
    ]
    
    public static var stages: [MigrationStage] = []
    
    
}
