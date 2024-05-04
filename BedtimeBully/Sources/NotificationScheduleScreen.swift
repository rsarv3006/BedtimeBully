import BedtimeBullyData
import SwiftData
import SwiftUI

struct NotificationScheduleScreen: View {
    @Query() private var bedtimeSchedules: [BedtimeScheduleTemplate]

    private var activeSchedule: NotificationSchedule? {
        return bedtimeSchedules.first(where: { $0.isActive })?.notificationSchedule
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
                        ForEach(activeSchedule.notificationMessages, id: \.self) { item in
                            Text(item)
                                .padding(.bottom)
                        }

                    } else {
                        Text("No active notification schedule found.")
                            .padding()
                    }

                    Spacer()
                }
            }
            .appBackground()
        }
        .navigationTitle("Notification Schedule")
        .navigationBarTitleDisplayMode(.inline)
    }
}
