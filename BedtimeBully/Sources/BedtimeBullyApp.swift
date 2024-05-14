import BedtimeBullyData
import SwiftData
import SwiftUI

@main
struct BedtimeBullyApp: App {
    @StateObject var bedtimeStore = BedtimeStore()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema(versionedSchema: SchemaV1_0_1.self)
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, migrationPlan: MigrationPlan.self, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(bedtimeStore)
        }
        .modelContainer(sharedModelContainer)
    }
}
