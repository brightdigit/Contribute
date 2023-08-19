//
//  PandocMarkdownGeneratorTests.swift
//  
//
//  Created by Ahmed Shendy on 19/08/2023.
//

import XCTest
@testable import Contribute

internal final class PandocMarkdownGeneratorTests: XCTestCase {

  internal func testSuccessfulMarkdownGeneration() throws {
    var isCalled: Bool?
    let sut = PandocMarkdownGenerator { _,_  in
      isCalled = true
      return "result"
    }

    let _ = try sut.markdown(fromHTML: "<html />")

    XCTAssertEqual(isCalled, true)
  }

  internal func testFailedMarkdownGeneration() throws {
    let sut = PandocMarkdownGenerator { _,_  in
      throw testError
    }

    XCTAssertThrowsError(try sut.markdown(fromHTML: "<html />"))
  }

}
