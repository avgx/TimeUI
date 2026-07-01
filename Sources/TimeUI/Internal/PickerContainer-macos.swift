#if os(macOS) || os(visionOS)
import SwiftUI

struct PickerContainer<Content: View>: View {
    @Binding var selection: Date
    let mode: PickerComponentMode
    let allowedFrom: Date?
    let allowedThrough: Date?
    @ViewBuilder let content: () -> Content

    @State private var showPopover = false

    private var displayedComponents: DatePickerComponents {
        switch mode {
        case .date: [.date]
        case .time: [.hourAndMinute]
        }
    }

    var body: some View {
        Button {
            showPopover = true
        } label: {
            content().pickerCapsuleStyled()
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showPopover, arrowEdge: .bottom) {
            datePicker
                .labelsHidden()
                .padding()
                .frame(minWidth: 280)
        }
    }

    @ViewBuilder
    private var datePicker: some View {
        if let allowedFrom, let allowedThrough {
            DatePicker(
                "",
                selection: $selection,
                in: allowedFrom...allowedThrough,
                displayedComponents: displayedComponents
            )
        } else if let allowedThrough {
            DatePicker(
                "",
                selection: $selection,
                in: ...allowedThrough,
                displayedComponents: displayedComponents
            )
        } else if let allowedFrom {
            DatePicker(
                "",
                selection: $selection,
                in: allowedFrom...,
                displayedComponents: displayedComponents
            )
        } else {
            DatePicker(
                "",
                selection: $selection,
                displayedComponents: displayedComponents
            )
        }
    }
}
#endif
