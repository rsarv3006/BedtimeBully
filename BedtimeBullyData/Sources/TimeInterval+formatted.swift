import Foundation

public extension TimeInterval {
    func formatted() -> String {
        let seconds = Int(self)

        let minutes = seconds / 60
        if minutes == 1 {
            return "1 minute"
        } else if minutes > 0 {
            return "\(minutes) minutes"
        }

        let hours = minutes / 60
        if hours == 1 {
            return "1 hour"
        } else if hours > 0 {
            return "\(hours) hours"
        }

        if seconds == 1 {
            return "1 second"
        } else {
            return "\(seconds) seconds"
        }
    }
    
    func getPrettyDate() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
