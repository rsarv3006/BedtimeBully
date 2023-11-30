//
//  BedtimeBullyApp.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/12/23.
//

import SwiftUI
import SwiftData

@main
struct BedtimeBullyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            NotificationSchedule.self,
            Bedtime.self,
            BedtimeSchedule.self
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
