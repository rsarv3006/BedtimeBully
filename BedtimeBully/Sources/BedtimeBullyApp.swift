import BedtimeBullyData
import SwiftData
import SwiftUI


@main
struct BedtimeBullyApp: App {
    @StateObject var storekitStore = StorekitStore()
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
                .environmentObject(storekitStore)
                .environment(\.appDatabase, .shared)
        }
        .modelContainer(sharedModelContainer)
    }
}

// MARK: - Give SwiftUI access to the database
//
// Define a new environment key that grants access to an AppDatabase.
//
// The technique is documented at
// <https://developer.apple.com/documentation/swiftui/environmentkey>.

private struct AppDatabaseKey: EnvironmentKey {
    static var defaultValue: AppDatabase { .empty() }
}

extension EnvironmentValues {
    var appDatabase: AppDatabase {
        get { self[AppDatabaseKey.self] }
        set { self[AppDatabaseKey.self] = newValue }
    }
}


