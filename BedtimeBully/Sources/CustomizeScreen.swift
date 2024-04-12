//
//  CustomizeScreen.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/27/23.
//

import SwiftUI
import SwiftData
import BedtimeBullyData

struct CustomizeScreen: View {
    @Query private var notificationSchedules: [NotificationSchedule]
    @State private var isUnlockPurchased = false
    @State private var selectedNotificationSchedule: NotificationSchedule?
    
//    @Query(bedtimeSchedulesFetch) private var bedtimeSchedules: [BedtimeSchedule]
//    
//    private var bedtimeSchedule: BedtimeSchedule? {
//        return bedtimeSchedules.first
//    }
//    
//    @State() private var bedtime: Date = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if !isUnlockPurchased {
                    Text("WIREFRAME: pick bedtime")
                    
                    Text("Need to further customize your bedtime? Purchase our advanced features to unlock custom bedtimes per day of the week and customize your notification schedule!")
                        .padding()
                }
                
                Picker("Selected Notification Schedule", selection: $selectedNotificationSchedule) {
                    ForEach(notificationSchedules, id: \.self) { schedule in
                        Text(schedule.name)
                    }
                }
                .disabled(!isUnlockPurchased)
                
                NotificationScheduleView(schedule: selectedNotificationSchedule)
                
                NavigationLink("Create New Notification Scedule") {
                    
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
                .disabled(!isUnlockPurchased)
                
                NavigationLink("Set Bedtime Schedule") {
                    
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
                
//                do {
//                    bedtime = try DataUtils.getBedtimeDateFromSchedule(bedtimeSchedule)
//                } catch {
//                    print("Error getting bedtime date from schedule: \(error)")
//                }
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
