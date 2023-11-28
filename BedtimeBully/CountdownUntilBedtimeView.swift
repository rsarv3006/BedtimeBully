//
//  CountdownTimerView.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/26/23.
//

import SwiftUI

struct CountdownUntilBedtimeView: View {
    @Binding var countdownToDate: Date

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            if hours == 0 && minutes == 0 && seconds == 0 {
                Text("It's bedtime!")
                    .font(.title3)
                    .padding()
            } else {
                Text(timeRemainingText)
                
            }
        }
        .onReceive(timer) { _ in
            updateCountdownComponents()
        }
    }

    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0

    private func updateCountdownComponents() {
        if countdownToDate < Date() {
            hours = 0
            minutes = 0
            seconds = 0
            return
        }
        
        let itemDate = Calendar.current.dateComponents([.hour, .minute, .second], from: countdownToDate)
        let nowDate = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        
        var hours = itemDate.hour! - nowDate.hour!
        var minutes = itemDate.minute! - nowDate.minute!
        var seconds = itemDate.second! - nowDate.second!
        
        if seconds < 0 {
            seconds += 60
            minutes -= 1
        }
        if minutes < 0 {
            minutes += 60
            hours -= 1
        }
        hours = max(0, hours)
        minutes = max(0, minutes)
        seconds = max(0, seconds)
        
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }

    private var timeRemainingText: String {
        "You have \(hours) hours, \(minutes) minutes and \(seconds) seconds until bedtime."
    }

}

#Preview {
    CountdownUntilBedtimeView(countdownToDate: .constant(Date().addingTimeInterval(30 * 60)))
}
