import BedtimeBullyData
import SwiftUI

public struct WeeklyBedtimeSceduleScreen: View {
    @Environment(\.appDatabase) private var appDatabase
    @EnvironmentObject() private var storekitStore: StorekitStore
    @StateObject private var viewModel: WeeklyBedtimeScheduleViewModel

    init(bedtimeSchedule: GRDBScheduleTemplate) {
        _viewModel = StateObject(wrappedValue: WeeklyBedtimeScheduleViewModel(schedule: bedtimeSchedule))
    }

    public var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    Button(action: {
                        viewModel.saveBedtimeSchedule(appDatabase)
                    }) {
                        Text("Save Bedtimes")
                    }
                    .padding(.vertical)
                    .alert("Weekly Bedtime Schedule has been updated", isPresented: $viewModel.showBedtimeHasUpdated) {}
                    .alert(viewModel.errorUpdatingBedtimeSchedule, isPresented: $viewModel.hasError) {}

                    BedtimeScheduleWeekSectionUpdate(title: "Sunday", bedtimeDate: $viewModel.sundayBedtime, isDateEnabled: $viewModel.isSundayEnabled)
                    BedtimeScheduleWeekSectionUpdate(title: "Monday", bedtimeDate: $viewModel.mondayBedtime, isDateEnabled: $viewModel.isMondayEnabled)
                    BedtimeScheduleWeekSectionUpdate(title: "Tuesday", bedtimeDate: $viewModel.tuesdayBedtime, isDateEnabled: $viewModel.isTuesdayEnabled)
                    BedtimeScheduleWeekSectionUpdate(title: "Wednesday", bedtimeDate: $viewModel.wednesdayBedtime, isDateEnabled: $viewModel.isWednesdayEnabled)
                    BedtimeScheduleWeekSectionUpdate(title: "Thursday", bedtimeDate: $viewModel.thursdayBedtime, isDateEnabled: $viewModel.isThursdayEnabled)
                    BedtimeScheduleWeekSectionUpdate(title: "Friday", bedtimeDate: $viewModel.fridayBedtime, isDateEnabled: $viewModel.isFridayEnabled)
                    BedtimeScheduleWeekSectionUpdate(title: "Saturday", bedtimeDate: $viewModel.saturdayBedtime, isDateEnabled: $viewModel.isSaturdayEnabled)
                }
                .frame(maxWidth: 350)

                if !storekitStore.hasPurchasedUnlockBedtimeSchedule {
                    VStack {
                        Text("To use the Weekly Bedtime Scheduler please unlock it on the Purchase page.")
                            .padding(.top, 40)
                        Spacer()

                        HStack {
                            Spacer()
                        }
                    }
                    .background(Color.black.opacity(0.6))
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                }
                HStack {
                    Spacer()
                }
            }
        }
    }
}
