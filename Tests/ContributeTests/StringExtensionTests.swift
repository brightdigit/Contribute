//
//  StringExtensionTests.swift
//  
//
//  Created by Ahmed Shendy on 23/08/2023.
//

import XCTest

final class StringExtensionTests: XCTestCase {

  func testFixUnicodeEscape() {
    let string = "’some string’"

    let expectedString = "'some string'"
    let actualString = string.fixUnicodeEscape()

    XCTAssertEqual(actualString, expectedString)
  }

  func testQequoteWhenEmptyString() {
    XCTAssertTrue("".dequote().isEmpty)
  }

  func testDequoteWhenQuotesAvailable() {
    let string = "\"some string\""
    let expectedString = "some string"
    let actualString = string.dequote()

    XCTAssertEqual(actualString, expectedString)
  }

  func testQequoteWhenNoQuote() {
    let string = "some string"
    let expectedString = "some string"
    let actualString = string.dequote()

    XCTAssertEqual(actualString, expectedString)
  }

  func testPadLeftWhenNotEmptyString() {
    let string = "some string"
    let padding = "- "

    let expectedString = padding + string
    let actualString = string.padLeft(
      totalWidth: string.count + padding.count,
      byString: padding
    )

    XCTAssertEqual(actualString, expectedString)
  }

  func testSlugifyWithNormalString() {
    let string = "2018 - My Year in Review"

    let expectedSlug = "2018-my-year-in-review"
    let actualSlug = string.slugify()

    XCTAssertEqual(actualSlug, expectedSlug)
  }

  func testSlugifyWitMessyString() {
    let string = " 2018 - ~!@##$%^&*()_+?><\":|}{;' My Year $ _   in _ Review   "

    let expectedSlug = "2018-my-year-in-review"
    let actualSlug = string.slugify()

    XCTAssertEqual(actualSlug, expectedSlug)
  }
}
