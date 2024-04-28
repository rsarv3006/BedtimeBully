import BedtimeBullyData
import Notifications
import SwiftData
import SwiftUI

public struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext

    @Query(filter: Bedtime.nextBedtimePredicate(Date()), sort: \.id, order: .forward) private var bedtimes: [Bedtime]
    @Query() private var configs: [Config]

    @State() private var bedtimeModel: Bedtime?
    @State() private var bedtime: Date = .init()
    @State() private var hasBedtime = false
    @State() private var shouldShowRequestNotificationPermissions = false

    public var body: some View {
        NavigationStack {
            VStack {
                BedtimeHomeDisplay(hasBedtime: $hasBedtime, bedtime: $bedtime, bedtimeModel: $bedtimeModel)

                NavigationLink("Customize") {
                    CustomizeScreen(bedtime: $bedtime, hasLoadedBedtime: $hasBedtime)
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .navigationTitle("BedtimeBully")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $shouldShowRequestNotificationPermissions) {
                RequestNotificationsPermissionView(
                    isModalPresented: $shouldShowRequestNotificationPermissions, config: configs.first
                ) {
                    DispatchQueue.main.async {
                        do {
                            try initializeBedtimeAndOtherData()
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsScreen()) {
                        Image(systemName: "gear")
                    }
                }
            }
            .onAppear {
                do {
                    try buildInitialData(modelContext)

                    if let config = configs.first {
                        hasBedtime = config.hasSetBedtime
                        shouldShowRequestNotificationPermissions = !config.isNotificationsEnabled

                        if config.isNotificationsEnabled && config.hasSetBedtime {
                            try initializeBedtimeAndOtherData()
                        }
                    }

                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }

    func initializeBedtimeAndOtherData() throws {
        try removeBedtimesAndNotificationsInThePast(modelContext: modelContext, currentDate: Date.now)

        try addBedtimesFromSchedule(modelContext)

        bedtimeModel = bedtimes.first

        print("Bedtime: \(bedtimeModel?.getPrettyDate() ?? "No bedtime found.") - homescreen")

        guard let bedtimeModel else {
            print("No bedtimes found.")
            return
        }

        bedtime = Date(timeIntervalSince1970: bedtimeModel.id)
        hasBedtime = true

        try addNotificationsForAllActiveBedtimes(modelContext: modelContext)
    }
}

#Preview {
    HomeScreen()
        .modelContainer(for: NotificationSchedule.self, inMemory: true)
}
