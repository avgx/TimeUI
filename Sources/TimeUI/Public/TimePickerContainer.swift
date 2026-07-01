import SwiftUI

public struct TimePickerContainer: View {
    @Binding private var selection: Date
    private let value: Date?

    public init(
        selection: Binding<Date>,
        value: Date? = nil
    ) {
        self._selection = selection
        self.value = value
    }

    private var effectiveDate: Date {
        value ?? selection
    }

    public var body: some View {
        PickerContainer(
            selection: $selection,
            mode: .time,
            allowedFrom: nil,
            allowedThrough: nil
        ) {
            TimeLabel(date: effectiveDate)
        }
    }
}
