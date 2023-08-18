import Foundation

struct MockFrontMatter: Codable {
  let title: String
  let date: String
  let description: String
  let featuredImage: String

  init(from source: MockSource) {
    title = source.title
    date = source.date
    description = source.description
    featuredImage = source.featuredImage
  }
}
