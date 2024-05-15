import BedtimeBullyData
import Notifications
import SwiftUI

public struct BedtimeScheduleScreen: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject() private var bedtimeStore: BedtimeStore

    @State private var newBedtime: Date = .init()
    @State private var hasError = false
    @State private var errorMessage = ""
    @State private var showBedtimeHasUpdated = false

    public var body: some View {
        NavigationStack {
            VStack {
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
                .alert("Error Encountered", isPresented: $hasError, actions: {}) {
                    Text(errorMessage)
                }
                .onAppear {
                    newBedtime = bedtimeStore.bedtime
                }

                Spacer()
            }
            .navigationTitle("Bedtime Schedule")
            .frame(maxWidth: 350)

            HStack {
                Spacer()
            }
        }
        .appBackground()
    }
}
