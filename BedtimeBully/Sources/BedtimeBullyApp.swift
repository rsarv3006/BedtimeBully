import BedtimeBullyData
import SwiftData
import SwiftUI


import SwiftUI
#if canImport(SwiftData)
import SwiftData
#endif

@main
struct BedtimeBullyApp: App {
    @StateObject var storekitStore = StorekitStore()
    @StateObject var bedtimeStore = BedtimeStore()
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *) {
                HomeScreen()
                    .environmentObject(bedtimeStore)
                    .environmentObject(storekitStore)
                    .environment(\.appDatabase, .shared)
                    .modelContainer(sharedModelContainer)
            } else {
                HomeScreen()
                    .environmentObject(bedtimeStore)
                    .environmentObject(storekitStore)
                    .environment(\.appDatabase, .shared)
            }
        }
    }
    
    @available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
    var sharedModelContainer: ModelContainer {
        let container: ModelContainer
        let schema = Schema(versionedSchema: SchemaV1_0_1.self)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            container = try ModelContainer(for: schema, migrationPlan: MigrationPlan.self, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
        return container
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


