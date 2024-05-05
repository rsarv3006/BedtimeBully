//
//  CustomizeScreen.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/27/23.
//

import BedtimeBullyData
import SwiftData
import SwiftUI

struct CustomizeScreen: View {
    @Environment(\.modelContext) private var modelContext

    @State private var newBedtime: Date
    @Binding var bedtime: Date
    @Binding var hasLoadedBedtime: Bool
    @State private var hasError = false
    @State private var errorMessage = ""

    init(bedtime: Binding<Date>, hasLoadedBedtime: Binding<Bool>) {
        _bedtime = bedtime
        _hasLoadedBedtime = hasLoadedBedtime
        _newBedtime = State(initialValue: bedtime.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
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
                                
                            } catch {
                                hasError = true
                                errorMessage = error.localizedDescription
                            }
                        }, label: {
                            Text("Save")
                        })
                    }
                    
                    HStack {
                        NavigationLink("Notification Schedule") {
                            NotificationScheduleScreen()
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                    }
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
        .navigationTitle("Customize")
        .navigationBarTitleDisplayMode(.inline)
    }
}
