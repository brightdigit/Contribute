//
//  PandocMarkdownGeneratorTests.swift
//  
//
//  Created by Ahmed Shendy on 19/08/2023.
//

import XCTest
@testable import Contribute

internal final class PandocMarkdownGeneratorTests: XCTestCase {

  internal func testSuccessfulMarkdownGenerate() throws {
    var isCalled: Bool?
    let sut = PandocMarkdownGenerator { _,_  in
      isCalled = true
      return "result"
    }

    let _ = try sut.markdown(fromHTML: "<html />")

    XCTAssertEqual(isCalled, true)
  }

  internal func testFailedMarkdownGenerate() throws {
    let sut = PandocMarkdownGenerator { _,_  in
      throw TestError.markdownGenerate
    }

    XCTAssertThrowsError(try sut.markdown(fromHTML: "<html />")) { actualError in
      guard let actualError = actualError as? TestError,
            actualError == .markdownGenerate else {
        XCTFail()
        return
      }
    }
  }

}
