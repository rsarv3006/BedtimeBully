import Notifications
import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("[Contact Support](https://rjsappdev.wixsite.com/bedtime-bully/general-5)")
                        .modifier(RoundedBorderView())
                        .frame(maxWidth: 350)

                    Text("[Privacy Policy](https://rjsappdev.wixsite.com/bedtime-bully/privacy-policy)")
                        .modifier(RoundedBorderView())
                        .frame(maxWidth: 350)

                    Text("[EULA](https://rjsappdev.wixsite.com/bedtime-bully/eula)")
                        .modifier(RoundedBorderView())
                        .frame(maxWidth: 350)
                    
                    HStack {
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
            .appBackground()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
