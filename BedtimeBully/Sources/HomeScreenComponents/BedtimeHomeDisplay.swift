import SwiftUI
import BedtimeBullyData

public struct BedtimeHomeDisplay: View {
    @Binding var hasBedtime: Bool
    @Binding var bedtime: Date

    private var beginNotifyingString: String {
        return "We will begin notifying you at \(DataUtils.calculateNotificationTime(bedtime: bedtime, notificationOffset: 30 * 60).formatted(date: .omitted, time: .shortened)) of your upcoming bedtime."
    }

    public var body: some View {
        Text("Welcome to Bedtime Bully! This app is designed to help you get to bed on time.")
            .padding(.horizontal)
            .padding(.bottom)

        Text("Today's Bedtime")
            .font(.title2)

        if hasBedtime {
            DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding(.bottom)
                .disabled(true)

        } else {
            Text("No bedtime scheduled for today.")
                .padding(.bottom)
        }

        CountdownUntilBedtimeView(countdownToDate: $bedtime)
            .multilineTextAlignment(.center)
            .padding(.horizontal)

        Text(beginNotifyingString)
            .multilineTextAlignment(.center)
            .padding()
    }
}
