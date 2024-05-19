import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    NavigationLink("Customize Bedtime Schedule") {
                        BedtimeScheduleScreen()
                    }
                    .padding(.vertical)

                    NavigationLink("Notification Schedule") {
                        NotificationScheduleScreen()
                    }
                    .padding(.bottom)

                    NavigationLink("Purchases") {
                        PurchasesScreen()
                    }
                    .padding(.bottom)

                    Text("[Contact Support](https://rjsappdev.wixsite.com/bedtime-bully/general-5)")
                        .padding(.bottom)

                    Text("[EULA](https://rjsappdev.wixsite.com/bedtime-bully/eula)")
                        .padding(.bottom)

                    Text("[Privacy Policy](https://rjsappdev.wixsite.com/bedtime-bully/privacy-policy)")
                        .padding(.bottom)

                    Button {
                        if let url = URL(string: "https://shiner.rjs-app-dev.us/") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Image(systemName: "pawprint.circle")
                    }
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
