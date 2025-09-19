import BedtimeBullyData
import NetworkConfig
import SwiftData
import SwiftUI

@main
struct BedtimeBullyApp: App {
    @StateObject var storekitStore = StorekitStore()
    @StateObject var bedtimeStore = BedtimeStore()
    @StateObject private var notificationManager: BackgroundRefresh = .init(appDb: .shared)
    
    var body: some Scene {
        WindowGroup {
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
