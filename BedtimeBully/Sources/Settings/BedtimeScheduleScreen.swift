import BedtimeBullyData
import SwiftData
import SwiftUI

public struct BedtimeScheduleScreen: View {
    @Environment(\.modelContext) private var modelContext
    @State private var segmentedControlSelected = 0

    @Query(filter: #Predicate<BedtimeScheduleTemplate> { schedule in
        schedule.isActive == true
    }) private var activeBedtimeSchedules: [BedtimeScheduleTemplate]

    public var body: some View {
        NavigationStack {
            VStack {
                Picker("Select Bedtime", selection: $segmentedControlSelected) {
                    Text("Global Bedtime").tag(0)
                    Text("Weekly Bedtime Schedule").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.top)
                .frame(maxWidth: 350)

                if segmentedControlSelected == 0 {
                    SingleBedtimeUpdateView()
                        .frame(maxWidth: 350)
                } else {
                    if let schedule = activeBedtimeSchedules.first {
                        WeeklyBedtimeSceduleScreen(bedtimeSchedule: schedule)
                    } else {
                        Text("No bedtime schedule found")
                    }
                }

                Spacer()
            }
            .navigationTitle("Bedtime Schedule")

            HStack {
                Spacer()
            }
        }
        .appBackground()
    }
}
