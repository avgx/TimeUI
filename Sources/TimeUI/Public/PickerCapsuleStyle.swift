import SwiftUI

public enum PickerCapsuleStyle: Sendable {
    /// Label only — foreground and padding, no capsule background.
    case clear
    /// Ultra-thin material capsule. Default; predictable over video.
    case material
    /// Liquid Glass capsule on iOS 26+; falls back to material on older iOS and other platforms.
    case glass
}

extension View {
    public func pickerCapsuleStyle(_ style: PickerCapsuleStyle) -> some View {
        environment(\.pickerCapsuleStyle, style)
    }
}
