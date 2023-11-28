//
//  HomeScreen.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/12/23.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var bedtime = Date().addingTimeInterval(60*60)
    
    private var beginNotifyingString: String {
        return "We will begin notifying you at \(DataUtils.calculateFirstNotificationTime(bedtime: bedtime, notificationOffset: 30 * 60).formatted(date: .omitted, time: .shortened)) of your impending bedtime."
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Bedtime Bully! This app is designed to help you get to bed on time.")
                    .padding(.horizontal)
                    .padding(.bottom)
                
                Text("Today's Bedtime")
                    .font(.title2)
                
                DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .padding(.bottom)
                
                CountdownUntilBedtimeView(countdownToDate: $bedtime)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(beginNotifyingString)
                    .multilineTextAlignment(.center)
                    .padding()
               
                NavigationLink("Customize") {
                    CustomizeScreen()
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
            .navigationTitle("BedtimeBully")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                do {
                    try buildInitialData(modelContext)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
        .modelContainer(for: NotificationSchedule.self, inMemory: true)
}
