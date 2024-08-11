import BedtimeBullyData
import GRDBQuery
import SwiftUI

struct NotificationScheduleScreen: View {
    @State private var openCustomizeSchedule = false

    @Query(NotificationScheduleRequest()) private var scheduleTemplates: [GRDBNotificationSchedule]

    private var activeSchedule: GRDBNotificationSchedule? {
        return scheduleTemplates.first(where: { $0.status == .active })
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack { Spacer() }

                    Text("This is the notification schedule used to notify you of an upcoming bedtime.")
                        .padding()

                    if let activeSchedule = activeSchedule {
                        ForEach(activeSchedule.notificationItems.items, id: \.self) { item in
                            Text(item.message)
                                .padding([.bottom, .horizontal])
                        }

                    } else {
                        Text("No active notification schedule found.")
                            .padding()
                    }

                    NavigationLink(destination: NotificationCustomizeScreen(scheduleName: activeSchedule?.name)) {
                        Text("Customize Notification Schedule")
                    }
                    .buttonStyle(.bordered)

                    Spacer()
                }
            }
            .appBackground()
        }
        .navigationTitle("Notification Schedule")
        .navigationBarTitleDisplayMode(.inline)
    }
}
