import BedtimeBullyData
import SwiftUI

public struct BedtimeHomeDisplay: View {
    @Environment(\.appDatabase) private var appDatabase
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
            Text("Today's Bedtime")
                .font(.headline)
                .foregroundColor(BedtimeColors.secondary)
                .onReceive(timer) { _ in
                    if bedtimeStore.hasBedtime {
                        withAnimation(.easeInOut) {
                            updateCountdownComponents()
                        }
                    }
                }

            if bedtimeStore.hasBedtime && hours <= 24 {
                DatePicker("", selection: $bedtimeStore.bedtime, displayedComponents: .hourAndMinute)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(BedtimeColors.accent)
                    .labelsHidden()
                    .padding(.bottom)
                    .disabled(true)

            } else {
                Text("No bedtime scheduled for today.")
                    .padding()
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(BedtimeColors.accent)
            }

            if hasSetCorrectCountdownTime {
                if (hours == 0 && minutes == 0 && seconds == 0) || hours == 23 {
                    Text("It's bedtime!")
                        .font(.title3)
                        .foregroundColor(BedtimeColors.accent)
                        .padding()
                } else {
                    CountdownUntilBedtimeView(hours: $hours, minutes: $minutes, seconds: $seconds)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                if hours == 0 && minutes < 60 && bedtimeStore.bedtimeModel?.status == .active {
                    Button {
                        shouldShowInBedModal = true
                    } label: {
                        Text("I'm in Bed")
                            .padding()
                            .background(BedtimeColors.accent)
                            .foregroundColor(BedtimeColors.background)
                            .clipShape(Capsule())
                    }
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
                        .foregroundColor(BedtimeColors.accent)
                }
            }

            if bedtimeStore.hasBedtime {
                Text(beginNotifyingString)
                    .font(.subheadline)
                    .foregroundColor(BedtimeColors.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            VStack {
                Text("Current Streak")
                    .font(.headline)
                    .foregroundColor(BedtimeColors.secondary)
                if let currentStreak = try? appDatabase.getBedtimeStreak() {
                    Text("\(currentStreak)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(BedtimeColors.accent)
                    Text("day\(currentStreak == 1 ? "" : "s") in a row!")
                        .font(.subheadline)
                        .foregroundColor(BedtimeColors.secondary)
                }
            }
            .padding()
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(BedtimeColors.accent, lineWidth: 2))
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
