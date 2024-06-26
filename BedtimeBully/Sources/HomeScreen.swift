import BedtimeBullyData
import Notifications
import SwiftData
import SwiftUI

public struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject() private var storekitStore: StorekitStore
    @EnvironmentObject() private var bedtimeStore: BedtimeStore

    @State private var bedtimes: [Bedtime] = []
    @Query() private var configs: [Config]

    @State() private var isLoadingStorekit = true
    @State() private var shouldShowRequestNotificationPermissions = false
    @State private var hasError = false
    @State private var errorMessage = ""

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    BedtimeHomeDisplay() {
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
                        isModalPresented: $shouldShowRequestNotificationPermissions, config: configs.first
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

                        if let config = configs.first {
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
        try removeBedtimesAndNotificationsInThePast(modelContext: modelContext, currentDate: Date())

        try addBedtimesFromSchedule(modelContext)

        let bedtimesFetchDescriptor: FetchDescriptor<Bedtime> = FetchDescriptor(
            predicate: Bedtime.nextBedtimePredicate(Date()),
            sortBy: [.init(\.id, order: .forward)]
        )

        let bedtimes = try modelContext.fetch(bedtimesFetchDescriptor)

        bedtimeStore.bedtimeModel = bedtimes.first

        guard let bedtimeModel = bedtimeStore.bedtimeModel else {
            throw BedtimeError.unableToGetBedtime
        }

        bedtimeStore.bedtime = Date(timeIntervalSince1970: bedtimeModel.id)
        bedtimeStore.hasBedtime = true

        try addNotificationsForAllActiveBedtimes(modelContext: modelContext)
    }
}
