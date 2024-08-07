import BedtimeBullyData
import NetworkConfig
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
    @StateObject private var notificationManager: BackgroundRefresh = .init(appDb: .shared)

    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *) {
                HomeScreen()
                    .environmentObject(bedtimeStore)
                    .environmentObject(storekitStore)
                    .environment(\.appDatabase, .shared)
                    .modelContainer(sharedModelContainer)
                    .onAppear {
                        onLoadMigrate()
                        notificationManager.registerBackgroundRefresh()
                    }
                    .checkAppVersion()
            } else {
                HomeScreen()
                    .environmentObject(bedtimeStore)
                    .environmentObject(storekitStore)
                    .environment(\.appDatabase, .shared)
                    .checkAppVersion()
                    .onAppear {
                        notificationManager.registerBackgroundRefresh()
                    }
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

    @available(iOS 17.0, macOS 14.0, macCatalyst 17.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
    func onLoadMigrate() {
        do {
            try AppDatabase.shared.updateScheduleFromSwiftData(sharedModelContainer.mainContext)
        } catch {
            print(error.localizedDescription)
        }
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
