import BedtimeBullyData
import GRDBQuery
import Notifications
import SwiftUI

public struct HomeScreen: View {
    @Environment(\.appDatabase) private var appDatabase
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject() private var storekitStore: StorekitStore
    @EnvironmentObject() private var bedtimeStore: BedtimeStore

    @State private var bedtimes: [Bedtime] = []
    @Query(ConfigRequest()) private var config: GRDBConfig?

    @State() private var isLoadingStorekit = true
    @State() private var shouldShowRequestNotificationPermissions = false
    @State private var hasError = false
    @State private var errorMessage = ""

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    BedtimeHomeDisplay {
                        DispatchQueue.main.async {
                            do {
                                try initializeBedtimeAndOtherData()
                            } catch {
                                hasError = true
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                }
                .navigationTitle("BedtimeBully")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $shouldShowRequestNotificationPermissions) {
                    RequestNotificationsPermissionView(
                        isModalPresented: $shouldShowRequestNotificationPermissions, config: config
                    ) {
                        DispatchQueue.main.async {
                            do {
                                try initializeBedtimeAndOtherData()
                            } catch {
                                hasError = true
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    .presentationDetents([.medium])
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsScreen()) {
                            Image(systemName: "gear")
                        }
                    }
                }
                .alert("Error Encountered", isPresented: $hasError, actions: {}) {
                    Text(errorMessage)
                }
                .onAppear {
                    do {
                        try buildInitialData(modelContext)

                        if let config {
                            bedtimeStore.hasBedtime = config.hasSetBedtime
                            shouldShowRequestNotificationPermissions = !config.isNotificationsEnabled

                            if config.isNotificationsEnabled && config.hasSetBedtime {
                                try initializeBedtimeAndOtherData()
                            }
                        }

                    } catch {
                        hasError = true
                        errorMessage = error.localizedDescription
                    }
                }
                HStack {
                    Spacer()
                }
                .onAppear {
                    Task {
                        await storekitStore.updateCustomerProductStatus()
                        isLoadingStorekit = false
                    }
                }
            }
            .appBackground()
        }
    }

    func initializeBedtimeAndOtherData() throws {
        try appDatabase.removeBedtimesAndNotificationsInThePast(currentDate: Date())

        try appDatabase.addBedtimesFromSchedule()


        let bedtimes = try appDatabase.getActiveBedtimes()
        bedtimeStore.bedtimeModel = bedtimes.first

        guard let bedtimeModel = bedtimeStore.bedtimeModel else {
            throw BedtimeError.unableToGetBedtime
        }

        bedtimeStore.bedtime = Date(timeIntervalSince1970: bedtimeModel.id)
        bedtimeStore.hasBedtime = true

        try addNotificationsForAllActiveBedtimes(modelContext: modelContext)
    }
}
