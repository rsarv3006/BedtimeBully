import Notifications
import SwiftUI
import BedtimeBullyData

struct SettingsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject() private var bedtimeStore: BedtimeStore

    @State private var newBedtime: Date = .init()
    @State private var hasError = false
    @State private var errorMessage = ""
    @State private var showBedtimeHasUpdated = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    HStack {
                        Text("Update Bedtime")
                        
                        Spacer()
                        
                            DatePicker("", selection: $newBedtime, displayedComponents: .hourAndMinute)
#if os(macOS)
                                .datePickerStyle(.graphical)
#endif
                                .labelsHidden()
                                .padding(.bottom)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            do {
                                try updateBedtimeAndNotifications(modelContext: modelContext, newBedtime: newBedtime)
                                bedtimeStore.bedtime = newBedtime
                                showBedtimeHasUpdated = true
                                
                            } catch {
                                hasError = true
                                errorMessage = error.localizedDescription
                            }
                        }, label: {
                            Text("Save")
                        })
                        .alert("", isPresented: $showBedtimeHasUpdated, actions: {}) {
                            Text("Bedtime has been updated.")
                        }
                    }

                     HStack {
                        NavigationLink("Customize Bedtime Schedule") {
                            BedtimeScheduleScreen()
                        }
                        .modifier(RoundedBorderView())
                    }
                    
                    HStack {
                        NavigationLink("Notification Schedule") {
                            NotificationScheduleScreen()
                        }
                        .modifier(RoundedBorderView())
                    }

                   
                    Text("[Contact Support](https://rjsappdev.wixsite.com/bedtime-bully/general-5)")
                        .modifier(RoundedBorderView())

                    Text("[Privacy Policy](https://rjsappdev.wixsite.com/bedtime-bully/privacy-policy)")
                        .modifier(RoundedBorderView())

                    Text("[EULA](https://rjsappdev.wixsite.com/bedtime-bully/eula)")
                        .modifier(RoundedBorderView())
                }
                .alert("Error Encountered", isPresented: $hasError, actions: {}) {
                    Text(errorMessage)
                }
                .frame(maxWidth: 350)
                
                HStack {
                    Spacer()
                }
            }
            .appBackground()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            newBedtime = bedtimeStore.bedtime
        }
    }
}
