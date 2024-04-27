import BedtimeBullyData
import SwiftUI

public struct BedtimeHomeDisplay: View {
    @Environment(\.modelContext) private var modelContext

    @Binding var hasBedtime: Bool
    @Binding var bedtime: Date
    @Binding var bedtimeModel: Bedtime?

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0

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

        CountdownUntilBedtimeView(hours: $hours, minutes: $minutes, seconds: $seconds)
            .multilineTextAlignment(.center)
            .padding(.horizontal)

        if hours == 0 && minutes < 60 && !(bedtimeModel?.hasGoneToBed ?? true) {
            Button {
                do {
                    if let bedtimeModel {
                        try removeUpcomingNotificationsForCurrentBedtime(modelContext: modelContext, currentBedtime: bedtimeModel)
                        bedtimeModel.hasGoneToBed = true
                        try modelContext.save()
                    }
                } catch {
                    print("Error: \(error)")
                }
            } label: {
                Text("I'm in Bed")
            }
            .buttonStyle(.bordered)
        } else if hours == 0 && minutes < 60 && bedtimeModel?.hasGoneToBed ?? true {
            Text("Good night! Sleep well!")
                .padding(.top)
        }

        Text(beginNotifyingString)
            .multilineTextAlignment(.center)
            .padding()
            .onReceive(timer) { _ in
                updateCountdownComponents()
            }
    }
}

// MARK: - Countdown Handlers

extension BedtimeHomeDisplay {
    private func updateCountdownComponents() {
        let now = Date()

        guard var bedtime = DateComponents(calendar: .current, year: now.year, month: now.month, day: now.day, hour: bedtime.hour, minute: bedtime.minute, second: bedtime.second).date else { return }

        if bedtime < Date() {
            bedtime = bedtime.addingTimeInterval(24 * 60 * 60)
        }

        let bedtimeTimeInterval = bedtime.timeIntervalSince(Date())

        let hours = Int(bedtimeTimeInterval) / 3600
        if hours >= 24 {
            self.hours = hours - 24
        } else {
            self.hours = hours
        }

        minutes = Int(bedtimeTimeInterval) / 60 % 60
        seconds = Int(bedtimeTimeInterval) % 60
    }
}
