//
//  MarkdownGenerator.swift
//  ContributeWordPress
//
//  Created by Leo Dion on 8/3/23.
//

import Foundation

public protocol MarkdownGenerator {
  func markdown(fromHTML htmlString: String) throws -> String
}
