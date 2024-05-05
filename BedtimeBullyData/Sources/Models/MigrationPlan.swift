//
//  BedtimeMigrationPlan.swift
//  BedtimeBullyData
//
//  Created by Robert J. Sarvis Jr on 5/5/24.
//

import Foundation
import SwiftData

public typealias Bedtime = BedtimeSchemaV1.Bedtime

enum BedtimeMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [BedtimeSchemaV1.self, BedtimeSchemaV2.self]
    }
    
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: BedtimeSchemaV1.self,
        toVersion: BedtimeSchemaV2.self,
        willMigrate: { context in
            // remove duplicates then save
        }, didMigrate: nil
    )
    
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
}
