import SwiftUI

public struct CountdownUntilBedtimeView: View {
    public var body: some View {
        ZStack {
            VStack {
                CircularProgressView(progress: calculateProgress(), timeRemaining: timeRemainingText)
                    .frame(width: 200, height: 200)
            }
        }
    }

    private func calculateProgress() -> Double {
        let totalSeconds = Double(hours * 3600 + minutes * 60 + seconds)
        let totalDaySeconds = 24.0 * 3600.0
        return 1.0 - (totalSeconds / totalDaySeconds)
    }

    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int

    private var timeRemainingText: String {
        "\(hours)h \(minutes)m \(seconds)s"
    }
}

#Preview {
    CountdownUntilBedtimeView(hours: .constant(1), minutes: .constant(30), seconds: .constant(0))
}
