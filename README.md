# TimeUI

Custom date and time picker HUD for VMS fullscreen camera playback.

Shows a custom-styled label while opening the **system** date/time picker on tap. Designed for iOS 15+, tvOS 18+, and macOS 12+.

## Components

| Component | Purpose |
|-----------|---------|
| `DateTimePickerContainer` | Main entry point — date + time with layout control |
| `DatePickerContainer` | Date-only capsule |
| `TimePickerContainer` | Time-only capsule (with ms and AM/PM) |
| `TimeLabel` | Standalone time display (ms + AM/PM), reusable outside pickers |

### Capsule style

Apply on the root HUD view — applies to all pickers inside:

```swift
public enum PickerCapsuleStyle {
    case clear     // label only, no background
    case material  // default — ultraThinMaterial
    case glass     // Liquid Glass on iOS 26+; material fallback elsewhere
}

DateTimePickerContainer(
    selection: $playbackDate,
    layout: .vstack,
    value: currentFrameTimestamp
)
.pickerCapsuleStyle(.glass)
.preferredColorScheme(.dark)
```

Default is `.material` when the modifier is omitted.

## Usage

```swift
import TimeUI

@State private var playbackDate = Date()
let currentFrameTimestamp: Date? = nil  // set during playback

// Full HUD — vertical panel from toolbar to timeline:
DateTimePickerContainer(
    selection: $playbackDate,
    layout: .vstack,
    value: currentFrameTimestamp
)
.frame(maxHeight: .infinity)

// Standalone time label:
TimeLabel(date: currentFrameTimestamp ?? playbackDate)
```

### Dark mode

Label text uses `.primary` and adapts to light/dark appearance together with `ultraThinMaterial`.

For fullscreen VMS over dark video, force dark appearance on the overlay:

```swift
DateTimePickerContainer(
    selection: $playbackDate,
    layout: .vstack,
    value: currentFrameTimestamp
)
.preferredColorScheme(.dark)
```

### Layout switching

Pass `layout` explicitly — the component does not detect orientation or size class. The parent decides based on its geometry:

```swift
GeometryReader { geo in
    let layout: DateTimePickerLayout =
        geo.size.height > geo.size.width ? .vstack : .hstack

    DateTimePickerContainer(
        selection: $playbackDate,
        layout: layout,
        value: currentFrameTimestamp
    )
    .animation(.default, value: layout)
}
```

- **`.vstack`** — date at top, time at bottom (above timeline), non-tappable `Spacer` between them
- **`.hstack`** — narrow horizontal strip under toolbar

### API

```swift
// selection — value changed by the user via system picker
// value       — displayed time (e.g. current playback frame); nil → selection

DatePickerContainer(
    selection: $date,
    value: frameTimestamp,
    allowedThrough: .now,       // upper bound (default: today)
    allowedFrom: archiveStart   // optional lower bound
)

TimePickerContainer(
    selection: $date,
    value: frameTimestamp
)
```

## Platforms

| Platform | Interaction |
|----------|-------------|
| **iOS** | Invisible `DatePicker` overlay on the custom label (opacity + scale) |
| **macOS / visionOS** | Click opens a **popover** with `DatePicker` |
| **tvOS** | Tap opens a **sheet** with custom SwiftUI stepper controls (year/month/day or hour/minute) |

## Limitations

- **Tap area (iOS)** — the invisible picker hit target may be smaller than the visible capsule; scaled overlay mitigates this but full coverage is not guaranteed on all OS versions
- **tvOS** — SwiftUI `DatePicker` is unavailable; sheet uses custom +/- button controls
- **Archive days** — only date *ranges* are supported (`allowedFrom` / `allowedThrough`); arbitrary sets of days with recordings require a custom calendar (future work)

## Design notes

Platform-specific picker interaction lives in `Internal/PickerContainer-*.swift`. Capsule label styling uses `View.pickerCapsuleStyled()` driven by `.pickerCapsuleStyle(_:)` on an ancestor view. `Spacer` areas in `DateTimePickerContainer` use `.allowsHitTesting(false)` so taps pass through to the video layer.
