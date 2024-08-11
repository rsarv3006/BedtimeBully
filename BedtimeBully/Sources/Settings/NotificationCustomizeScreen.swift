import BedtimeBullyData
import SwiftUI

struct NotificationCustomizeScreen: View {
    @Environment(\.appDatabase) private var appDatabase
    @State private var selection: NotificationMessageType = .Standard
    @State private var didError = false
    @State private var errorMessage = ""
    @State private var didUpdateNotificationItems = false

    var body: some View {
        ScrollView {
            HStack { Spacer() }

            Text("Change the notification message style.")

            Picker("Select a Notification Message Type", selection: $selection) {
                ForEach(NotificationMessageType.allCases, id: \.self) { item in
                    Text(item.rawValue)
                }
            }

            Button(action: {
                do {
                    didError = false
                    errorMessage = ""

                    var notificationItems: [NotificationItem] = []

                    switch selection {
                    case .Standard:
                        notificationItems = DefaultNotificationItems
                    case .Aggressive:
                        notificationItems = AggressiveNotificationItems
                    case .Aussie:
                        notificationItems = AussieNotificationItems
                    }

                    try appDatabase.replaceNotificationSchedule(with: notificationItems)

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
            .alert("Updated Message Type Successfully!", isPresented: $didUpdateNotificationItems) {}
            .alert("Error Encountered", isPresented: $didError, actions: {}) {
                Text(errorMessage)
            }

            Spacer()
        }
        .appBackground()
    }
}
