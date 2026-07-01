#if os(iOS)
import SwiftUI

private enum PickerOverlayMetrics {
    static let scaleX: CGFloat = 3
    static let scaleY: CGFloat = 2
    static let opacity: Double = 0.015
}

struct PickerContainer<Content: View>: View {
    @Binding var selection: Date
    let mode: PickerComponentMode
    let allowedFrom: Date?
    let allowedThrough: Date?
    @ViewBuilder let content: () -> Content

    private var displayedComponents: DatePickerComponents {
        switch mode {
        case .date: [.date]
        case .time: [.hourAndMinute]
        }
    }

    var body: some View {
        content()
            .pickerCapsuleStyled()
            .overlay {
                invisiblePicker
            }
    }

    private var invisiblePicker: some View {
        datePicker
            .labelsHidden()
            .opacity(PickerOverlayMetrics.opacity)
            .allowsHitTesting(true)
            .scaleEffect(x: PickerOverlayMetrics.scaleX, y: PickerOverlayMetrics.scaleY)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .clipped()
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
