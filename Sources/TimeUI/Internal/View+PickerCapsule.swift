import SwiftUI

private enum PickerCapsuleStyleKey: EnvironmentKey {
    static let defaultValue: PickerCapsuleStyle = .material
}

extension EnvironmentValues {
    var pickerCapsuleStyle: PickerCapsuleStyle {
        get { self[PickerCapsuleStyleKey.self] }
        set { self[PickerCapsuleStyleKey.self] = newValue }
    }
}

private struct PickerCapsuleBackgroundModifier: ViewModifier {
    @Environment(\.pickerCapsuleStyle) private var style

    func body(content: Content) -> some View {
        switch style {
        case .clear:
            content
        case .material:
            content.background(.ultraThinMaterial.opacity(0.7), in: .capsule)
        case .glass:
            glassBackground(for: content)
        }
    }

    @ViewBuilder
    private func glassBackground(for content: Content) -> some View {
#if os(iOS)
        if #available(iOS 26, *) {
            content.glassEffect(.regular.interactive(), in: .capsule)
        } else {
            content.background(.ultraThinMaterial.opacity(0.7), in: .capsule)
        }
#else
        content.background(.ultraThinMaterial.opacity(0.7), in: .capsule)
#endif
    }
}

extension View {
    func pickerCapsuleLabel() -> some View {
        foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }

    func pickerCapsuleStyled() -> some View {
        pickerCapsuleLabel()
            .modifier(PickerCapsuleBackgroundModifier())
    }
}
