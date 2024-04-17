import SwiftUI

public struct CountdownUntilBedtimeView: View {
    @Binding var countdownToDate: Date

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    public var body: some View {
        ZStack {
            if hours == 0 && minutes == 0 && seconds == 0 {
                Text("It's bedtime!")
                    .font(.title3)
                    .padding()
            } else {
                Text(timeRemainingText)
            }
        }
        .onReceive(timer) { _ in
            updateCountdownComponents()
        }
    }

    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0

    private func updateCountdownComponents() {
        let now = Date()

        guard let bedtime = DateComponents(calendar: .current, year: now.year, month: now.month, day: now.day, hour: countdownToDate.hour, minute: countdownToDate.minute, second: countdownToDate.second).date else { return }

        countdownToDate = bedtime

        if countdownToDate < Date() {
            countdownToDate = countdownToDate.addingTimeInterval(24 * 60 * 60)
        }

        let bedtimeTimeInterval = countdownToDate.timeIntervalSince(Date())

        let hours = Int(bedtimeTimeInterval) / 3600
        if hours >= 24 {
            self.hours = hours - 24
        } else {
            self.hours = hours
        }

        minutes = Int(bedtimeTimeInterval) / 60 % 60
        seconds = Int(bedtimeTimeInterval) % 60
    }

    private var timeRemainingText: String {
        "You have \(hours) hours, \(minutes) minutes and \(seconds) seconds until bedtime."
    }
}

#Preview {
    CountdownUntilBedtimeView(countdownToDate: .constant(Date().addingTimeInterval(30 * 60)))
}
