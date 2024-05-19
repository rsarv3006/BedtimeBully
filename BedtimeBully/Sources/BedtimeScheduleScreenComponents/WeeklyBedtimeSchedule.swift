import BedtimeBullyData
import SwiftData
import SwiftUI

public struct WeeklyBedtimeSceduleScreen: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: WeeklyBedtimeScheduleViewModel

    init(bedtimeSchedule: BedtimeScheduleTemplate) {
        _viewModel = StateObject(wrappedValue: WeeklyBedtimeScheduleViewModel(schedule: bedtimeSchedule))
    }

    public var body: some View {
        ScrollView {
            VStack {
                Button(action: {
                    viewModel.saveBedtimeSchedule(modelContext)
                }) {
                    Text("Save Bedtimes")
                }
                .alert("Weekly Bedtime Schedule has been updated", isPresented: $viewModel.showBedtimeHasUpdated) {}

                BedtimeScheduleWeekSectionUpdate(title: "Sunday", bedtimeDate: $viewModel.sundayBedtime, isDateEnabled: $viewModel.isSundayEnabled)
                BedtimeScheduleWeekSectionUpdate(title: "Monday", bedtimeDate: $viewModel.mondayBedtime, isDateEnabled: $viewModel.isMondayEnabled)
                BedtimeScheduleWeekSectionUpdate(title: "Tuesday", bedtimeDate: $viewModel.tuesdayBedtime, isDateEnabled: $viewModel.isTuesdayEnabled)
                BedtimeScheduleWeekSectionUpdate(title: "Wednesday", bedtimeDate: $viewModel.wednesdayBedtime, isDateEnabled: $viewModel.isWednesdayEnabled)
                BedtimeScheduleWeekSectionUpdate(title: "Thursday", bedtimeDate: $viewModel.thursdayBedtime, isDateEnabled: $viewModel.isThursdayEnabled)
                BedtimeScheduleWeekSectionUpdate(title: "Friday", bedtimeDate: $viewModel.fridayBedtime, isDateEnabled: $viewModel.isFridayEnabled)
                BedtimeScheduleWeekSectionUpdate(title: "Saturday", bedtimeDate: $viewModel.saturdayBedtime, isDateEnabled: $viewModel.isSaturdayEnabled)
            }
            .frame(maxWidth: 350)

            HStack {
                Spacer()
            }
        }
    }
}
