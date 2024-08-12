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
                VStack {
                    HStack { Spacer() }
                    
                    VStack(alignment: .leading) {
                        Text("This is the notification schedule used to notify you of an upcoming bedtime.")
                            .foregroundStyle(Color.accentColor)
                            .padding()
                        
                        if let activeSchedule = activeSchedule {
                            ScrollView {
                                VStack(alignment: .leading) {
                                    ForEach(activeSchedule.notificationItems.items, id: \.self) { item in
                                        Text(item.message)
                                            .padding([.bottom, .horizontal])
                                    }
                                }
                            }
                        } else {
                            Text("No active notification schedule found.")
                                .padding()
                        }
                    }
                    
                    
                    Spacer()
            }
            .appBackground()
        }
        .navigationTitle("Notification Schedule")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: NotificationCustomizeScreen(scheduleName: activeSchedule?.name)) {
                    Text("Customize")
                }
            }
        }
    }
}
