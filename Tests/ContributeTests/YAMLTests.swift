import XCTest
@testable import Contribute

final class YAMLTests: XCTestCase {

  func testValidDateFormat() {
    XCTAssertEqual(
      YAML.dateFormatter.dateFormat,
      "yyyy-MM-dd HH:mm"
    )
  }

  func testValidTimezone() {
    XCTAssertEqual(
      YAML.dateFormatter.timeZone,
      TimeZone.current
    )
  }
}
