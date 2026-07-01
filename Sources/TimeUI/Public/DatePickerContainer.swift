import SwiftUI

public struct DatePickerContainer: View {
    @Binding private var selection: Date
    private let value: Date?
    private let allowedFrom: Date?
    private let allowedThrough: Date

    @Environment(\.locale) private var locale

    public init(
        selection: Binding<Date>,
        value: Date? = nil,
        allowedThrough: Date = .now,
        allowedFrom: Date? = nil
    ) {
        self._selection = selection
        self.value = value
        self.allowedFrom = allowedFrom
        self.allowedThrough = allowedThrough
    }

    private var effectiveDate: Date {
        value ?? selection
    }

    public var body: some View {
        PickerContainer(
            selection: $selection,
            mode: .date,
            allowedFrom: allowedFrom,
            allowedThrough: allowedThrough
        ) {
            Text(effectiveDate.formatted(Date.FormatStyle(date: .complete, time: .omitted, locale: locale)))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}
