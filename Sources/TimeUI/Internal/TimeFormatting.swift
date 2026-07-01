import Foundation

enum TimeFormatting {
    static func ampmSuffix(from hourWithAMPM: String) -> String {
        let parts = hourWithAMPM.split(whereSeparator: \.isWhitespace)
        return parts.count > 1 ? String(parts[1]) : ""
    }
}
