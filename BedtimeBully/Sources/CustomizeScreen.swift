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
                                // TODO: Handle this better
                                print("Error: \(error)")
                            }
                        }, label: {
                            Text("Save")
                        })
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .navigationTitle("Customize")
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

    return CustomizeScreen(bedtime: .constant(Date()), hasLoadedBedtime: .constant(false))
        .modelContainer(container)
}
