import SwiftUI

struct PickerStyledContent<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial.opacity(0.7), in: .capsule)
    }
}
