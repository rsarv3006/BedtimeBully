import BedtimeBullyData
import SwiftUI

struct NotificationCustomizeScreen: View {
    @Environment(\.appDatabase) private var appDatabase
    @State private var selection: NotificationMessageType
    @State private var didError = false
    @State private var errorMessage = ""
    @State private var didUpdateNotificationItems = false

    public init(scheduleName: String?) {
        switch scheduleName {
        case NotificationMessageType.Aussie.rawValue:
            selection = .Aussie
        case NotificationMessageType.Aggressive.rawValue:
            selection = .Aggressive
        default:
            selection = .Standard
        }
    }

    var body: some View {
        ScrollView {
            HStack { Spacer() }

            Text("Change the notification message tone.")

            Picker("Select a Notification Message Tone", selection: $selection) {
                ForEach(NotificationMessageType.allCases, id: \.self) { item in
                    Text(item.rawValue)
                }
            }

            Button(action: {
                do {
                    didError = false
                    errorMessage = ""

                    try appDatabase.setNotificationSchedule(variant: selection)

                    try appDatabase.removeAllBedtimesAndNotifications()
                    try appDatabase.addBedtimesFromSchedule()

                    didUpdateNotificationItems = true
                } catch {
                    didError = true
                    errorMessage = error.localizedDescription
                }
            }) {
                Text("Save")
            }
            .buttonStyle(.bordered)
            .alert("Updated Message Tone Successfully!", isPresented: $didUpdateNotificationItems) {}
            .alert("Error Encountered", isPresented: $didError, actions: {}) {
                Text(errorMessage)
            }

            Spacer()
        }
        .appBackground()
    }
}
