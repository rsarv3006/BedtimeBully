import BedtimeBullyData
import SwiftData
import SwiftUI

@main
struct BedtimeBullyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            NotificationSchedule.self,
            Bedtime.self,
            BedtimeScheduleTemplate.self,
            Config.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
        .modelContainer(sharedModelContainer)
    }
}
