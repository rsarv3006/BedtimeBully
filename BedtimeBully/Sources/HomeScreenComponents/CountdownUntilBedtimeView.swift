import SwiftUI

public struct CountdownUntilBedtimeView: View {
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
    }

    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int

    private var timeRemainingText: String {
        """
        You have
        \(hours) hours, \(minutes) minutes and \(seconds) seconds
        until bedtime.
        """
    }
}

#Preview {
    CountdownUntilBedtimeView(hours: .constant(1), minutes: .constant(30), seconds: .constant(0))
}
