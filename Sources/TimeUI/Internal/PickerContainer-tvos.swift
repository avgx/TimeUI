#if os(tvOS)
import SwiftUI

struct PickerContainer<Content: View>: View {
    @Binding var selection: Date
    let mode: PickerComponentMode
    let allowedFrom: Date?
    let allowedThrough: Date?
    @ViewBuilder let content: () -> Content

    @State private var showSheet = false

    private var sheetTitle: String {
        switch mode {
        case .date: "Select Date"
        case .time: "Select Time"
        }
    }

    var body: some View {
        PickerStyledContent(content: content)
            .onTapGesture {
                showSheet = true
            }
            .sheet(isPresented: $showSheet) {
                TVDateTimePickerSheet(
                    selection: $selection,
                    mode: mode,
                    allowedFrom: allowedFrom,
                    allowedThrough: allowedThrough,
                    title: sheetTitle
                )
            }
    }
}
#endif
