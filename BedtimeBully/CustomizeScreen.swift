//
//  CustomizeScreen.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/27/23.
//

import SwiftUI
import SwiftData

struct CustomizeScreen: View {
    @Query private var notificationSchedules: [NotificationSchedule]
    @State private var isUnlockPurchased = true
    @State private var selectedNotificationSchedule: NotificationSchedule?
   
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Selected Notification Schedule", selection: $selectedNotificationSchedule) {
                    ForEach(notificationSchedules, id: \.self) { schedule in
                        Text(schedule.name)
                    }
                }
                
                NotificationScheduleView(schedule: selectedNotificationSchedule)
                
                NavigationLink("Create New Notification Scedule") {
                    
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
                .disabled(!isUnlockPurchased)
                
                NavigationLink("Set Weekly Bedtime Schedule") {
                    
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
                .disabled(!isUnlockPurchased)
                
                Spacer()
            }
            .navigationTitle("Customize")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                if selectedNotificationSchedule == nil {
                    selectedNotificationSchedule = notificationSchedules.first
                }
            })
        }
    }
}

#Preview {
    let schema = Schema([
        NotificationSchedule.self,
        Bedtime.self,
        BedtimeSchedule.self
    ])
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema,
        configurations: config)
    
    try! buildInitialData(container.mainContext)
    
    return CustomizeScreen()
        .modelContainer(container)
}
