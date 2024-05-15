import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
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
