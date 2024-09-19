import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let timeRemaining: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(BedtimeColors.accent, lineWidth: 10)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    BedtimeColors.secondary,
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
            
            Text(timeRemaining)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(BedtimeColors.accent)
                .multilineTextAlignment(.center)
        }
    }
}
