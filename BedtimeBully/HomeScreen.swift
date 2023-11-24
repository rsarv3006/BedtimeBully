//
//  HomeScreen.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/12/23.
//

import SwiftUI

struct HomeScreen: View {
   @State private var bedtime = Date()
    
    var body: some View {
        VStack {
            Text("Bedtime Bully")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Text("Welcome to Bedtime Bully! This app is designed to help you get to bed on time.")
                .padding(.horizontal)
                .padding(.bottom)
            
            Text("Today's Bedtime")
                .font(.title2)
                .fontWeight(.bold)
            
            DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                .labelsHidden()
            
            

            Spacer()
            
        }
    }
}

#Preview {
    HomeScreen()
}
