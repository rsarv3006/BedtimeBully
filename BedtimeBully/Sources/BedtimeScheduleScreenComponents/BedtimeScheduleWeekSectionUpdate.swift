import SwiftUI

public struct BedtimeScheduleWeekSectionUpdate: View {
    let title: String
    @Binding var bedtimeDate: Date
    @Binding var isDateEnabled: Bool

    public var body: some View {
        VStack {
            Toggle(title, isOn: $isDateEnabled)
            HStack {
                Spacer()

                if isDateEnabled {
                    DatePicker("", selection: $bedtimeDate, displayedComponents: .hourAndMinute)
                    #if os(macOS)
                        .datePickerStyle(.graphical)
                    #endif
                        .labelsHidden()
                        .padding(.bottom)
                }
            }
        }
        .padding()
    }
}
