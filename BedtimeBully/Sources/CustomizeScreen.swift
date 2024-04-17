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
    
    @Query private var bedtimes: [Bedtime]
    @Query private var notificationItems: [NotificationItem]

    @State() private var potentialNewBedtime: Date = .init()
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    bedtimes.forEach { bedtime in
                        print("*** BEDTIME ***")
                        print(bedtime.name)
                        print(bedtime.id)
                        print(Date(timeIntervalSince1970: bedtime.id).description)
                        print(bedtime.notificationItems?.count ?? 0)
                    }
                }, label: {
                    Text("LOG BEDTIMES")
                })
                
                Button(action: {
                    notificationItems.forEach { notificationItem in
                        print("*** NOTIFICATION ITEM ***")
                        print(notificationItem.id)
                        print(Date(timeIntervalSince1970: notificationItem.id).description)
                    }
                }, label: {
                    Text("LOG NOTIFICATION ITEMS")
                })
                
                VStack {
                    Text("Update Bedtime")
                        .font(.title2)
                    
                    DatePicker("", selection: $potentialNewBedtime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding(.bottom)
                    
                    Button(action: {}, label: {
                        Text("Save")
                    })
                }
                
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
        BedtimeScheduleTemplate.self
    ])

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema,
                                        configurations: config)

    try! buildInitialData(container.mainContext)

    return CustomizeScreen()
        .modelContainer(container)
}
