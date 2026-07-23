# Release Notes

## Unreleased

Wave 0 merge (brightdigit/Contribute #14, head `brightdigit-com-260621`) — subrepo
tracking branch synced into the default branch via `git subrepo push`.

### Library

- `SwiftSoupMarkdownGenerator` gains `markdown(fromHTML:selecting:)`, which converts
  only the elements matching a SwiftSoup-compatible CSS selector to Markdown, rendering
  matches in document order without their layout ancestors. Useful for template HTML
  (e.g. email layouts) where authored content is wrapped in nested presentation tables.
  Returns an empty string when the selector matches nothing.

### Tests

- Added `SwiftSoupSelectedContentTests`, covering selector-based extraction that omits
  email layout chrome and the empty-result case when the selector does not match.

### CI

- `build-macos` and `build-macos-platforms` moved from the self-hosted macOS runner to
  the GitHub-hosted `xcode-27` runner, using `/Applications/Xcode_27.0.app`.
- `build-macos-platforms` sets `download-platform: true` for downloadable 27.0 simulator
  runtimes.
- Added a reusable `.github/actions/setup-tools` composite action that caches the mise
  tool installs and puts the binaries on PATH; the lint job now consumes it instead of
  invoking `jdx/mise-action` directly.
