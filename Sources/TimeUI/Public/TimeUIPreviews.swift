import SwiftUI

#if DEBUG
private let previewAfternoon: Date = {
    var components = DateComponents()
    components.calendar = Calendar(identifier: .gregorian)
    components.timeZone = TimeZone(secondsFromGMT: 0)
    components.year = 2012
    components.month = 8
    components.day = 4
    components.hour = 19
    components.minute = 30
    components.second = 45
    components.nanosecond = 123_000_000
    return components.date!
}()

private enum PreviewAppearance {
    case light
    case dark
    case vms

    var colorScheme: ColorScheme {
        switch self {
        case .light: .light
        case .dark, .vms: .dark
        }
    }
}

private struct PreviewBackground: View {
    let appearance: PreviewAppearance

    var body: some View {
        Group {
            switch appearance {
            case .light:
                lightBackground
            case .dark:
                Color(white: 0.15)
            case .vms:
                Color.black
            }
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var lightBackground: some View {
#if os(macOS)
        Color(nsColor: .windowBackgroundColor)
#elseif os(iOS)
        Color(uiColor: .systemGroupedBackground)
#else
        Color.gray.opacity(0.2)
#endif
    }
}

private struct PreviewContainer: View {
    @State private var date: Date
    let appearance: PreviewAppearance

    init(date: Date = Date(), appearance: PreviewAppearance = .vms) {
        _date = State(initialValue: date)
        self.appearance = appearance
    }

    var body: some View {
        ZStack {
            PreviewBackground(appearance: appearance)

            VStack(spacing: 24) {
                DatePickerContainer(selection: $date)
                TimePickerContainer(selection: $date)

                Text(date.formatted())
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .preferredColorScheme(appearance.colorScheme)
    }
}

private struct TimeLabelPreviewContainer: View {
    let date: Date
    let appearance: PreviewAppearance

    var body: some View {
        ZStack {
            PreviewBackground(appearance: appearance)

            TimeLabel(date: date)
                .padding()
        }
        .preferredColorScheme(appearance.colorScheme)
    }
}

private struct DateTimePreviewContainer: View {
    @State private var date: Date
    let layout: DateTimePickerLayout
    let appearance: PreviewAppearance

    init(
        date: Date = Date(),
        layout: DateTimePickerLayout,
        appearance: PreviewAppearance = .vms
    ) {
        _date = State(initialValue: date)
        self.layout = layout
        self.appearance = appearance
    }

    var body: some View {
        ZStack {
            PreviewBackground(appearance: appearance)

            DateTimePickerContainer(
                selection: $date,
                layout: layout
            )
            .padding()

            VStack {
                Spacer()
                Text(date.formatted())
                    .foregroundStyle(.secondary)
                    .padding()
            }
            .ignoresSafeArea()
        }
        .preferredColorScheme(appearance.colorScheme)
    }
}

#Preview("Current Light") {
    PreviewContainer(appearance: .light)
}

#Preview("Current Dark") {
    PreviewContainer(appearance: .dark)
}

#Preview("VMS Dark") {
    PreviewContainer(appearance: .vms)
}

#if os(iOS)
#Preview("Glass VMS") {
    PreviewContainer(date: previewAfternoon, appearance: .vms)
        .pickerCapsuleStyle(.glass)
        .environment(\.locale, Locale(identifier: "en_US"))
}

#Preview("Clear VMS") {
    PreviewContainer(date: previewAfternoon, appearance: .vms)
        .pickerCapsuleStyle(.clear)
        .environment(\.locale, Locale(identifier: "en_US"))
}
#endif

#Preview("TimeLabel en_US Light") {
    TimeLabelPreviewContainer(date: previewAfternoon, appearance: .light)
        .environment(\.locale, Locale(identifier: "en_US"))
}

#Preview("TimeLabel en_US VMS") {
    TimeLabelPreviewContainer(date: previewAfternoon, appearance: .vms)
        .environment(\.locale, Locale(identifier: "en_US"))
}

#Preview("TimeLabel ru_RU Light") {
    TimeLabelPreviewContainer(date: previewAfternoon, appearance: .light)
        .environment(\.locale, Locale(identifier: "ru_RU"))
}

#Preview("en_US 12h Light") {
    PreviewContainer(date: previewAfternoon, appearance: .light)
        .environment(\.locale, Locale(identifier: "en_US"))
}

#Preview("en_US 12h Dark") {
    PreviewContainer(date: previewAfternoon, appearance: .dark)
        .environment(\.locale, Locale(identifier: "en_US"))
}

#Preview("en_US 12h VMS") {
    PreviewContainer(date: previewAfternoon, appearance: .vms)
        .environment(\.locale, Locale(identifier: "en_US"))
}

#Preview("ru_RU 24h Light") {
    PreviewContainer(date: previewAfternoon, appearance: .light)
        .environment(\.locale, Locale(identifier: "ru_RU"))
}

#Preview("ru_RU 24h Dark") {
    PreviewContainer(date: previewAfternoon, appearance: .dark)
        .environment(\.locale, Locale(identifier: "ru_RU"))
}

#Preview("VStack 12h Light") {
    DateTimePreviewContainer(date: previewAfternoon, layout: .vstack, appearance: .light)
        .environment(\.locale, Locale(identifier: "en_US"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
}

#Preview("VStack 12h VMS") {
    DateTimePreviewContainer(date: previewAfternoon, layout: .vstack, appearance: .vms)
        .environment(\.locale, Locale(identifier: "en_US"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
}

#Preview("HStack 12h Light") {
    DateTimePreviewContainer(date: previewAfternoon, layout: .hstack, appearance: .light)
        .environment(\.locale, Locale(identifier: "en_US"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
}

#Preview("HStack 12h VMS") {
    DateTimePreviewContainer(date: previewAfternoon, layout: .hstack, appearance: .vms)
        .environment(\.locale, Locale(identifier: "en_US"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
}
#endif
