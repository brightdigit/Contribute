@testable import Contribute
import XCTest

// TODO: @Leo, I don't feel this is correct testing at all.
internal final class YAMLTests: XCTestCase {
  internal func testValidDateFormat() {
    XCTAssertEqual(
      YAML.dateFormatter.dateFormat,
      "yyyy-MM-dd HH:mm"
    )
  }

  internal func testValidTimezone() {
    XCTAssertEqual(
      YAML.dateFormatter.timeZone,
      TimeZone.current
    )
  }
}
