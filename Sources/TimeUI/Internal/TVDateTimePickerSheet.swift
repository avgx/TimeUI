#if os(tvOS)
import SwiftUI

struct TVDateTimePickerSheet: View {
    @Binding var selection: Date
    let mode: PickerComponentMode
    let allowedFrom: Date?
    let allowedThrough: Date?
    let title: String

    @Environment(\.dismiss) private var dismiss
    @Environment(\.locale) private var locale
    @Environment(\.calendar) private var calendar

    @State private var workingDate: Date

    init(
        selection: Binding<Date>,
        mode: PickerComponentMode,
        allowedFrom: Date?,
        allowedThrough: Date?,
        title: String
    ) {
        self._selection = selection
        self.mode = mode
        self.allowedFrom = allowedFrom
        self.allowedThrough = allowedThrough
        self.title = title
        self._workingDate = State(initialValue: selection.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                switch mode {
                case .date:
                    dateControls
                case .time:
                    timeControls
                }
            }
            .padding(48)
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        selection = clamp(workingDate)
                        dismiss()
                    }
                }
            }
        }
    }

    private var dateControls: some View {
        VStack(spacing: 24) {
            TVStepperRow(
                label: "Year",
                value: String(calendar.component(.year, from: workingDate))
            ) {
                adjust(.year, by: -1)
            } increment: {
                adjust(.year, by: 1)
            }

            TVStepperRow(
                label: "Month",
                value: workingDate.formatted(
                    Date.FormatStyle(locale: locale).month(.wide)
                )
            ) {
                adjust(.month, by: -1)
            } increment: {
                adjust(.month, by: 1)
            }

            TVStepperRow(
                label: "Day",
                value: String(calendar.component(.day, from: workingDate))
            ) {
                adjust(.day, by: -1)
            } increment: {
                adjust(.day, by: 1)
            }
        }
    }

    private var timeControls: some View {
        VStack(spacing: 24) {
            TVStepperRow(
                label: "Hour",
                value: workingDate.formatted(
                    Date.FormatStyle(locale: locale)
                        .hour(.twoDigits(amPM: .omitted))
                )
            ) {
                adjust(.hour, by: -1)
            } increment: {
                adjust(.hour, by: 1)
            }

            TVStepperRow(
                label: "Minute",
                value: workingDate.formatted(
                    Date.FormatStyle(locale: locale).minute(.twoDigits)
                )
            ) {
                adjust(.minute, by: -1)
            } increment: {
                adjust(.minute, by: 1)
            }
        }
    }

    private func adjust(_ component: Calendar.Component, by value: Int) {
        guard let candidate = calendar.date(byAdding: component, value: value, to: workingDate) else {
            return
        }
        workingDate = clamp(candidate)
    }

    private func clamp(_ date: Date) -> Date {
        var clamped = date
        if let allowedThrough, clamped > allowedThrough {
            clamped = allowedThrough
        }
        if let allowedFrom, clamped < allowedFrom {
            clamped = allowedFrom
        }
        return clamped
    }
}

private struct TVStepperRow: View {
    let label: String
    let value: String
    let decrement: () -> Void
    let increment: () -> Void

    var body: some View {
        HStack(spacing: 24) {
            Text(label)
                .frame(width: 140, alignment: .leading)

            Button(action: decrement) {
                Image(systemName: "minus")
                    .frame(width: 88, height: 64)
            }
            .buttonStyle(.bordered)

            Text(value)
                .frame(minWidth: 200)
                .multilineTextAlignment(.center)

            Button(action: increment) {
                Image(systemName: "plus")
                    .frame(width: 88, height: 64)
            }
            .buttonStyle(.bordered)
        }
    }
}
#endif
