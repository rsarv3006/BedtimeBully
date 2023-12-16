//
//  HomeScreen.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/12/23.
//

import SwiftUI
import SwiftData

enum BedtimeScheduleError: Error {
    case noBedtimeSchedule
    case unableToGetBedtime
}

let bedtimeSchedulePredicate = #Predicate<BedtimeSchedule> { bedtimeSchedule in
    bedtimeSchedule.isActive == true
}

let bedtimeSchedulesFetch = FetchDescriptor<BedtimeSchedule>(predicate: bedtimeSchedulePredicate)

struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
  
    @Query(bedtimeSchedulesFetch) private var bedtimeSchedules: [BedtimeSchedule]
    
    private var bedtimeSchedule: BedtimeSchedule? {
        return bedtimeSchedules.first
    }
    
    @State() private var bedtime: Date = Date()
    
    private var beginNotifyingString: String {
        return "We will begin notifying you at \(DataUtils.calculateNotificationTime(bedtime: bedtime, notificationOffset: 30 * 60).formatted(date: .omitted, time: .shortened)) of your impending bedtime."
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
                    
                    bedtime = try getBedtimeDate()
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func getBedtimeDate() throws -> Date {
        guard let bedtimeSchedule = bedtimeSchedule else { throw BedtimeScheduleError.noBedtimeSchedule }
        let today = Date()
        let dayOfWeek = today.dayOfWeek
        
        if let bedtime = bedtimeSchedule.getBedtime(dayOfWeek: dayOfWeek) {
            
            let time = bedtime.bedtime
            let bedtimeDate = try? time.toDate(baseDate: Date())
            
                
            if let todayBedtimeDate = bedtimeDate {
                if !todayBedtimeDate.isInPast {
                    return todayBedtimeDate
                } else {
                    if let tomorrowBedtimeDate = try? time.toDate(baseDate: Date.tomorrow) {
                        return tomorrowBedtimeDate
                    }
                }
            }
        }
        
        throw BedtimeScheduleError.unableToGetBedtime
    }
}

#Preview {
    HomeScreen()
        .modelContainer(for: NotificationSchedule.self, inMemory: true)
}
