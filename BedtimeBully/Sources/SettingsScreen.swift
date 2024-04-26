//
//  SettingsScreen.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 12/18/23.
//

import BedtimeBullyData
import SwiftData
import SwiftUI

struct SettingsScreen: View {
    @Query private var bedtimes: [Bedtime]
    @Query private var notificationItems: [NotificationItem]

    var body: some View {
        VStack {
            Button(action: {
                for bedtime in bedtimes {
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
                for notificationItem in notificationItems {
                    print("*** NOTIFICATION ITEM ***")
                    print(notificationItem.id)
                    print(Date(timeIntervalSince1970: notificationItem.id).description)
                }
                
                print(notificationItems.count)
            }, label: {
                Text("LOG NOTIFICATION ITEMS")
            })
        }
    }
}

#Preview {
    let schema = Schema([
        NotificationSchedule.self,
        Bedtime.self,
        BedtimeScheduleTemplate.self,
    ])

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema,
                                        configurations: config)

    try! buildInitialData(container.mainContext)

    return SettingsScreen()
        .modelContainer(container)
}
