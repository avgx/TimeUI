import Testing
@testable import TimeUI

@Test func ampmSuffixWithRegularSpace() {
    #expect(TimeFormatting.ampmSuffix(from: "3 PM") == "PM")
}

@Test func ampmSuffixWithNarrowNoBreakSpace() {
    #expect(TimeFormatting.ampmSuffix(from: "3\u{202F}PM") == "PM")
}

@Test func ampmSuffixWithNoSuffix() {
    #expect(TimeFormatting.ampmSuffix(from: "15") == "")
}

@Test func ampmSuffixWithMultipleWhitespace() {
    #expect(TimeFormatting.ampmSuffix(from: "3  \u{00A0}AM") == "AM")
}
