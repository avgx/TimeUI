import SwiftUI

public struct TimeLabel: View {
    let date: Date

    @Environment(\.locale) private var locale

    public init(date: Date) {
        self.date = date
    }

    private var timeStyle: Date.FormatStyle {
        Date.FormatStyle(locale: locale)
            .hour(.defaultDigits(amPM: .omitted))
            .minute(.twoDigits)
            .second(.twoDigits)
    }

    private var msStyle: Date.FormatStyle {
        Date.FormatStyle(locale: locale)
            .secondFraction(.fractional(3))
    }

    private var ampmStyle: Date.FormatStyle {
        Date.FormatStyle(locale: locale)
            .hour(.defaultDigits(amPM: .abbreviated))
    }

    public var body: some View {
        let ampm = TimeFormatting.ampmSuffix(from: date.formatted(ampmStyle))
        let baseFont = Font.system(size: 20, weight: .semibold, design: .monospaced)
        let msFont = Font.system(size: 14, weight: .light, design: .monospaced)

        (Text(date.formatted(timeStyle))
            + Text(".\(date.formatted(msStyle))").font(msFont)
            + Text(ampm.isEmpty ? "" : " \(ampm)"))
            .font(baseFont)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
}
