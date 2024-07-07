import BedtimeBullyData
import SwiftUI

public struct BedtimeHomeDisplay: View {
    @Environment(\.appDatabase) private var appDatabase
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject() private var bedtimeStore: BedtimeStore

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var hasSetCorrectCountdownTime = false
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0

    var onDateTickOver: () -> Void

    @State private var shouldShowInBedModal = false

    private var beginNotifyingString: String {
        return "We will begin notifying you at \(DataUtils.calculateNotificationTime(bedtime: bedtimeStore.bedtime, notificationOffset: 30 * 60).formatted(date: .omitted, time: .shortened)) of your upcoming bedtime."
    }

    public var body: some View {
        VStack {
            Text("Welcome to Bedtime Bully! This app is designed to help you get to bed on time.")
                .padding(.horizontal)
                .padding(.bottom)
                .onReceive(timer) { _ in
                    if bedtimeStore.hasBedtime {
                        updateCountdownComponents()
                    }
                }

            Text("Today's Bedtime")
                .font(.title2)

            if bedtimeStore.hasBedtime && hours <= 24 {
                DatePicker("", selection: $bedtimeStore.bedtime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .padding(.bottom)
                    .disabled(true)

            } else {
                Text("No bedtime scheduled for today.")
                    .padding()
            }

            if hasSetCorrectCountdownTime {
                if (hours == 0 && minutes == 0 && seconds == 0) || hours == 23 {
                    Text("It's bedtime!")
                        .font(.title3)
                        .padding()
                } else {
                    CountdownUntilBedtimeView(hours: $hours, minutes: $minutes, seconds: $seconds)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                if hours == 0 && minutes < 60 {
                    Button {
                        shouldShowInBedModal = true
                    } label: {
                        Text("I'm in Bed")
                    }
                    .buttonStyle(.bordered)
                    .alert("Going to Bed?", isPresented: $shouldShowInBedModal) {
                        Button("Yes") {
                            do {
                                if let bedtimeModel = bedtimeStore.bedtimeModel {
                                    let _ = try appDatabase.convertBedtimeToHistory(bedtimeModel)
                                    bedtimeStore.bedtimeModel = nil
                                }
                            } catch {
                                print("Error: \(error)")
                            }
                        }

                        Button("No") {}
                    } message: {
                        Text("""
                        Are you sure you're in bed?
                        Clicking Yes will silence further bedtime notifications for today.
                        """)
                    }

                } else if hours == 0 && minutes < 60 {
                    Text("Good night! Sleep well!")
                        .padding(.top)
                }
            }

            if bedtimeStore.hasBedtime {
                Text(beginNotifyingString)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

// MARK: - Countdown Handlers

extension BedtimeHomeDisplay {
    private func updateCountdownComponents() {
        let now = Date()

        if bedtimeStore.bedtime < now {
            onDateTickOver()
        }

        let bedtimeTimeInterval = bedtimeStore.bedtime.timeIntervalSince(now)

        hours = Int(bedtimeTimeInterval) / 3600

        minutes = Int(bedtimeTimeInterval) / 60 % 60
        seconds = Int(bedtimeTimeInterval) % 60

        if !hasSetCorrectCountdownTime {
            hasSetCorrectCountdownTime = true
        }
    }
}
