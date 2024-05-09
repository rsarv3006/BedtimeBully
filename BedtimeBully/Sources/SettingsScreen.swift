import Notifications
import SwiftUI
import BedtimeBullyData

struct SettingsScreen: View {
    @Environment(\.modelContext) private var modelContext

    @State private var newBedtime: Date
    @Binding var bedtime: Date
    @Binding var hasLoadedBedtime: Bool
    @State private var hasError = false
    @State private var errorMessage = ""
    @State private var showBedtimeHasUpdated = false

    init(bedtime: Binding<Date>, hasLoadedBedtime: Binding<Bool>) {
        _bedtime = bedtime
        _hasLoadedBedtime = hasLoadedBedtime
        _newBedtime = State(initialValue: bedtime.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    HStack {
                        Text("Update Bedtime")
                        
                        Spacer()
                        
                        if hasLoadedBedtime {
                            DatePicker("", selection: $newBedtime, displayedComponents: .hourAndMinute)
#if os(macOS)
                                .datePickerStyle(.graphical)
#endif
                                .labelsHidden()
                                .padding(.bottom)
                        } else {
                            Text("Bedtime not found")
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            do {
                                try updateBedtimeAndNotifications(modelContext: modelContext, newBedtime: newBedtime)
                                bedtime = newBedtime
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
                        NavigationLink("Notification Schedule") {
                            NotificationScheduleScreen()
                        }
                        .modifier(RoundedBorderView())
                        
                        Spacer()
                    }

                    HStack {
                        NavigationLink("Customize Bedtime Schedule") {
                            BedtimeScheduleScreen()
                        }
                        .modifier(RoundedBorderView())
                        
                        Spacer()
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
    }
}
