//
//  SettingsScreen.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 12/18/23.
//

import SwiftUI
import Notifications

struct SettingsScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("[Contact Support](https://rjsappdev.wixsite.com/bedtime-bully/general-5)")
                        .modifier(RoundedBorderView())
                    
                    Text("[Privacy Policy](https://rjsappdev.wixsite.com/bedtime-bully/privacy-policy)")
                        .modifier(RoundedBorderView())
                    
                    Text("[EULA](https://rjsappdev.wixsite.com/bedtime-bully/eula)")
                        .modifier(RoundedBorderView())

                    
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

#Preview {
    return SettingsScreen()
}
