import BedtimeBullyData
import GRDBQuery
import SwiftUI

struct NotificationScheduleScreen: View {
    @State private var openCustomizeSchedule = false

    @Query(NotificationScheduleRequest()) private var scheduleTemplates: [GRDBNotificationSchedule]

    private var activeSchedule: GRDBNotificationSchedule? {
        return scheduleTemplates.first(where: { $0.name == "Default" })
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                    }

                    Text("This is the notification schedule used to notify you of an upcoming bedtime.")
                        .padding()

                    if let activeSchedule = activeSchedule {
                        ForEach(activeSchedule.notificationItems.items, id: \.self) { item in
                            Text(item.message)
                                .padding(.bottom)
                        }

                    } else {
                        Text("No active notification schedule found.")
                            .padding()
                    }

                    Button(action: {
                           openCustomizeSchedule.toggle() 
                        }) {
                        Text("Customize Notification Schedule")
                    }
                    .buttonStyle(.bordered)
                    .alert("Coming Soon!", isPresented: $openCustomizeSchedule, actions: {})


                    Spacer()
                }
            }
            .appBackground()
        }
        .navigationTitle("Notification Schedule")
        .navigationBarTitleDisplayMode(.inline)
    }
}
