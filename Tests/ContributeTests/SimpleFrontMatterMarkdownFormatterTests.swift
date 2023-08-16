@testable import Contribute
import XCTest

internal final class SimpleFrontMatterMarkdownFormatterTests: XCTestCase {
  private let formatter: SimpleFrontMatterMarkdownFormatter = .simple

  internal func testValidFrontMatterAndMarkdownTextShouldReturnValidFormattedText() {
    let frontMatter = """
title: 2018 - My Year in Review
date: 2019-01-14 07:49
description: My main goal this year was to produce more content online and less time on local events and gatherings. Unfortunately, that wasn't the case.
featuredImage: /media/wp-assets/leogdion/2019/01/image-e1547230562842-1024x682.jpg
"""

    let markdownText = """
## My Goals for 2018

As I said I removed many activities from my life mostly networking and
meetups from my schedule. This is because **I am better off showcasing
my talent to a wider audience online.** This includes meetups which I no
longer related to.

<figure class="wp-block-image">
<img
src="/media/wp-assets/leogdion/2019/01/image-e1547230562842-1024x682.jpg"
class="wp-image-105" alt="A JavaScript Meetup I hosted in 2018 " />
<figcaption>A JavaScript Meetup I hosted in 2018</figcaption>
</figure>
"""

    XCTAssertEqual(
      formatter.format(frontMatterText: frontMatter, withMarkdown: markdownText),
      self.format(frontMatterText: frontMatter, withMarkdown: markdownText)
    )
  }
}

extension SimpleFrontMatterMarkdownFormatterTests: FrontMatterMarkdownFormatter {
  func format(frontMatterText: String, withMarkdown markdownText: String) -> String {
    ["---", frontMatterText, "---", markdownText].joined(separator: "\n")
  }
}
