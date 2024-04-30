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
        NavigationStack {
            ScrollView {
                VStack {
                    Text("[Contact Support](https://rjsappdev.wixsite.com/bedtime-bully/general-5)")
                        .modifier(RoundedBorderView())
                    
                    Text("[Privacy Policy](https://rjsappdev.wixsite.com/bedtime-bully/privacy-policy)")
                        .modifier(RoundedBorderView())
                    
                    Text("[EULA](https://rjsappdev.wixsite.com/bedtime-bully/eula)")
                        .modifier(RoundedBorderView())

                    
                    HStack {
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
            .appBackground()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
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
