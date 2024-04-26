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

    var body: some View {
        VStack {
            Button(action: {
                for bedtime in bedtimes {
                    print("*** BEDTIME ***")
                    print(bedtime.name)
                    print(bedtime.id)
                    print(bedtime.getPrettyDate())
                    print(bedtime.notificationItems.count)
                }
            }, label: {
                Text("LOG BEDTIMES")
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
