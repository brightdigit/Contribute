<p align="center">
  <img src="Sources/Contribute/Documentation.docc/Resources/ContributeLogo.png" alt="Contribute" height="100" />
</p>

<h1 align="center">Contribute</h1>

<p align="center">Create content for your site from existing sources.</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT" /></a>
  <img src="https://img.shields.io/badge/Swift-5.8%2B-orange.svg" alt="Swift 5.8+" />
  <img src="https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg" alt="Platforms" />
</p>

---

## What is Contribute?

Static site generators are great for blog posts you write by hand — but most of a site's content already lives somewhere else: a YouTube channel, RSS feeds, a newsletter archive, an old CMS export. **Contribute turns those source items into clean markdown files with YAML front matter**, ready to drop into your generator's content folder.

It does this with one small, reusable shape so you don't write a bespoke importer per source. You write two tiny conformances per source; the fetch + extract + write pipeline stays the same.

> **Scope:** Contribute does **not** fetch from APIs. You bring the already-decoded source models — use [SyndiKit](https://github.com/brightdigit/SyndiKit) for RSS, a client for the YouTube API, your CMS's export, etc. Contribute's job starts there: **source model → markdown file.**

`brightdigit.com` uses Contribute to import its podcast episodes, videos, and newsletters into a Swift static site generator.

## The core idea: one trio

Two protocols do the per-source work, and a third binds them to a single source model.

| Protocol | Responsibility |
| --- | --- |
| `FrontMatterTranslator` | Map a source item's fields onto your site's (`Encodable`) front matter. |
| `MarkdownExtractor` | Render a source item's body into markdown, using an injected HTML→markdown function. |
| `ContentType` | Bind one `SourceType` to *its* translator and extractor — and get a generic `write(...)` for free. |

```swift
public protocol FrontMatterTranslator {
  associatedtype SourceType
  associatedtype FrontMatterType: Encodable
  init()
  func frontMatter(from source: SourceType) -> FrontMatterType
}

public protocol MarkdownExtractor {
  associatedtype SourceType
  init()
  func markdown(
    from source: SourceType,
    using htmlToMarkdown: @escaping (String) throws -> String
  ) throws -> String
}

public protocol ContentType {
  associatedtype SourceType
  associatedtype MarkdownExtractorType: MarkdownExtractor
    where MarkdownExtractorType.SourceType == SourceType
  associatedtype FrontMatterTranslatorType: FrontMatterTranslator
    where FrontMatterTranslatorType.SourceType == SourceType
}
```

`SourceType` is *your* model — Contribute never defines it and never fetches it. That seam is what keeps the library source-agnostic.

## Installation

Add Contribute to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/brightdigit/Contribute.git", from: "1.0.0")
]
```

Then add it to a target:

```swift
.target(
  name: "MySite",
  dependencies: [.product(name: "Contribute", package: "Contribute")]
)
```

## Quick start

Say you've already fetched an RSS feed into an array of your own `RSSItem` values and want one markdown file per entry.

```swift
import Contribute
import Foundation

// 1. Your site's front matter — anything Encodable.
struct PostFrontMatter: Encodable {
  let title: String
  let date: Date
  let tags: [String]
}

// 2. Your already-decoded source model. Conform to HTMLSource to reuse the
//    built-in FilteredHTMLMarkdownExtractor for the body.
struct RSSItem: HTMLSource {
  let title: String
  let published: Date
  let categories: [String]
  let html: String   // satisfies HTMLSource
}

// 3. A ContentType binds the source to its translator + extractor.
enum RSSContent: ContentType {
  typealias SourceType = RSSItem
  typealias FrontMatterTranslatorType = FrontMatter
  typealias MarkdownExtractorType = FilteredHTMLMarkdownExtractor<RSSItem>

  struct FrontMatter: FrontMatterTranslator {
    func frontMatter(from item: RSSItem) -> PostFrontMatter {
      PostFrontMatter(
        title: item.title,
        date: item.published,
        tags: item.categories
      )
    }
  }
}

// 4. Write every item to disk. The pipeline is generic over the trio.
let htmlToMarkdown = SwiftSoupMarkdownGenerator().markdown(fromHTML:)

try RSSContent.write(
  from: items,                                   // [RSSItem] you fetched
  atContentPathURL: URL(fileURLWithPath: "Content/posts"),
  fileNameWithoutExtension: { $0.title.lowercased().replacingOccurrences(of: " ", with: "-") },
  using: htmlToMarkdown,
  options: .init(shouldOverwriteExisting: true, includeMissingPrevious: false)
)
```

Each file is written as YAML front matter (encoded with [Yams](https://github.com/jpsim/Yams)) followed by the extracted markdown body:

```markdown
---
title: My Episode Title
date: 2026-06-29T12:00:00Z
tags:
  - swift
  - podcast
---

The body, converted from HTML to clean markdown.
```

## Adding another source

Every source is the same shape with different field mappings. Want YouTube, Mailchimp, or a WordPress export? Decode it into your own model, then write a `ContentType` with a `FrontMatterTranslator` (and a `MarkdownExtractor` if the body isn't plain `HTMLSource`). The `write(...)` call site never changes.

```swift
enum YouTubeContent: ContentType {
  typealias SourceType = YouTubeVideo
  typealias FrontMatterTranslatorType = FrontMatter
  typealias MarkdownExtractorType = FilteredHTMLMarkdownExtractor<YouTubeVideo>

  struct FrontMatter: FrontMatterTranslator {
    func frontMatter(from video: YouTubeVideo) -> PostFrontMatter {
      PostFrontMatter(title: video.title, date: video.publishedAt, tags: video.tags)
    }
  }
}
```

## What's in the box

- **`SwiftSoupMarkdownGenerator`** — a [SwiftSoup](https://github.com/brightdigit/SwiftSoup)-backed HTML→markdown converter (built on [swift-markdown](https://github.com/swiftlang/swift-markdown)). Pass its `markdown(fromHTML:)` as the `using:` argument.
- **`PassthroughMarkdownGenerator`** — use `.shared` when your source body is already markdown.
- **`FilteredHTMLMarkdownExtractor<Source: HTMLSource>`** — a ready-made `MarkdownExtractor` for any source that exposes `var html: String`.
- **`FrontMatterYAMLExporter`** — encodes your `Encodable` front matter to YAML.
- **`FileNameGenerator` / `ContentURLGenerator`** — control the destination file name/path per source.
- **`MarkdownContentBuilderOptions`** — `shouldOverwriteExisting` (overwrite existing files) and `includeMissingPrevious` (controls pruning of items that have disappeared from the source).

## How the pipeline works

`ContentType.write(...)` is generic over the trio and identical for every source. For each item it:

1. translates front matter (`FrontMatterTranslator` → YAML via `FrontMatterYAMLExporter`),
2. extracts the markdown body (`MarkdownExtractor`, using the injected `htmlToMarkdown`),
3. joins them and writes the file at a destination derived from `ContentURLGenerator`.

Options handle overwriting existing files and pruning entries that have dropped out of the source feed.

## Requirements

- Swift 5.8+
- macOS 12+, iOS 13+, tvOS 13+, watchOS 6+

## License

[MIT](LICENSE) © BrightDigit
