import SwiftUI

public struct TimePickerContainer: View {
    @Binding private var selection: Date
    private let value: Date?
    private let allowedFrom: Date?
    private let allowedThrough: Date?

    public init(
        selection: Binding<Date>,
        value: Date? = nil,
        allowedFrom: Date? = nil,
        allowedThrough: Date? = nil
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
            mode: .time,
            allowedFrom: allowedFrom,
            allowedThrough: allowedThrough
        ) {
            TimeLabel(date: effectiveDate)
        }
    }
}
