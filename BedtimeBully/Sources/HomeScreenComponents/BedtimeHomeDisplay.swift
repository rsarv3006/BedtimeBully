import BedtimeBullyData
import SwiftData
import SwiftUI

public struct BedtimeHomeDisplay: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject() private var bedtimeStore: BedtimeStore

    @Binding var hasBedtime: Bool
    @Binding var bedtimeModel: Bedtime?
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var hasSetCorrectCountdownTime = false
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    
    var onDateTickOver: () -> Void
    
    @State private var shouldShowInBedModal = false
    
    private var beginNotifyingString: String {
        return "We will begin notifying you at \(DataUtils.calculateNotificationTime(bedtime: bedtimeStore.bedtime, notificationOffset: 30 * 60).formatted(date: .omitted, time: .shortened)) of your upcoming bedtime."
    }
    
    public var body: some View {
        VStack {
            Text("Welcome to Bedtime Bully! This app is designed to help you get to bed on time.")
                .padding(.horizontal)
                .padding(.bottom)
                .onReceive(timer) { _ in
                    if hasBedtime {
                        updateCountdownComponents()
                    }
                }
            
            Text("Today's Bedtime")
                .font(.title2)
            
            if hasBedtime {
                DatePicker("", selection: $bedtimeStore.bedtime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .padding(.bottom)
                    .disabled(true)
                
            } else {
                Text("No bedtime scheduled for today.")
                    .padding()
            }
            
            
            if hasSetCorrectCountdownTime {
                if (hours == 0 && minutes == 0 && seconds == 0) || hours == 23 {
                    Text("It's bedtime!")
                        .font(.title3)
                        .padding()
                } else {
                    CountdownUntilBedtimeView(hours: $hours, minutes: $minutes, seconds: $seconds)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                if hours == 0 && minutes < 60 && !(bedtimeModel?.hasGoneToBed ?? true) {
                    Button {
                        shouldShowInBedModal = true
                    } label: {
                        Text("I'm in Bed")
                    }
                    .buttonStyle(.bordered)
                    .alert("Going to Bed?", isPresented: $shouldShowInBedModal) {
                        Button("Yes") {
                            do {
                                if let bedtimeModel {
                                    bedtimeModel.removeUpcomingNotificationsForCurrentBedtime()
                                    bedtimeModel.hasGoneToBed = true
                                    
                                    let bedtimeHistory = BedtimeHistory(bedtimeTarget: bedtimeModel.id, inBedTime: Date().timeIntervalSince1970, status: .valid)
                                    modelContext.insert(bedtimeHistory)
                                    try modelContext.save()
                                }
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                        
                        Button("No") {}
                    } message: {
                        Text("""
                             Are you sure you're in bed?
                             Clicking Yes will silence further bedtime notifications for today.
                             """)
                    }
                    
                } else if hours == 0 && minutes < 60 && bedtimeModel?.hasGoneToBed ?? true {
                    Text("Good night! Sleep well!")
                        .padding(.top)
                }
            }
            
            if hasBedtime {
                Text(beginNotifyingString)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
        }
    }
}

// MARK: - Countdown Handlers

extension BedtimeHomeDisplay {
    private func updateCountdownComponents() {
        let now = Date()
        
        if bedtimeStore.bedtime < now {
            onDateTickOver()
        }
        
        let bedtimeTimeInterval = bedtimeStore.bedtime.timeIntervalSince(now)
        
        let hours = Int(bedtimeTimeInterval) / 3600
        if hours >= 24 {
            self.hours = hours - 24
        } else {
            self.hours = hours
        }
        
        minutes = Int(bedtimeTimeInterval) / 60 % 60
        seconds = Int(bedtimeTimeInterval) % 60
        
        if !hasSetCorrectCountdownTime {
            hasSetCorrectCountdownTime = true
        }
    }
}
