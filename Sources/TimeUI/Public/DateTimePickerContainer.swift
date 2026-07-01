import SwiftUI

public enum DateTimePickerLayout: Sendable {
    case vstack
    case hstack
}

public struct DateTimePickerContainer: View {
    @Binding private var selection: Date
    private let value: Date?
    private let layout: DateTimePickerLayout
    private let allowedThrough: Date
    private let allowedFrom: Date?

    public init(
        selection: Binding<Date>,
        layout: DateTimePickerLayout,
        value: Date? = nil,
        allowedThrough: Date = .now,
        allowedFrom: Date? = nil
    ) {
        self._selection = selection
        self.layout = layout
        self.value = value
        self.allowedThrough = allowedThrough
        self.allowedFrom = allowedFrom
    }

    public var body: some View {
        switch layout {
        case .vstack:
            vstackLayout
        case .hstack:
            hstackLayout
        }
    }

    private var vstackLayout: some View {
        VStack(spacing: 0) {
            DatePickerContainer(
                selection: $selection,
                value: value,
                allowedThrough: allowedThrough,
                allowedFrom: allowedFrom
            )
            .frame(maxWidth: .infinity, alignment: .top)

            Spacer()
                .allowsHitTesting(false)

            TimePickerContainer(
                selection: $selection,
                value: value
            )
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var hstackLayout: some View {
        HStack(spacing: 12) {
            DatePickerContainer(
                selection: $selection,
                value: value,
                allowedThrough: allowedThrough,
                allowedFrom: allowedFrom
            )

            Spacer(minLength: 0)
                .allowsHitTesting(false)

            TimePickerContainer(
                selection: $selection,
                value: value
            )
        }
        .frame(maxWidth: .infinity)
    }
}
