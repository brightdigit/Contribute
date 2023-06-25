import Foundation

extension String {
  private static let quotes = ["\"", "'"]

  private static let slugSafeCharacters = CharacterSet(
    charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-"
  )

  public func fixUnicodeEscape() -> String {
    replacingOccurrences(of: "’", with: "'")
  }

  public func dequote() -> String {
    let trimmedString = trimmingCharacters(in: .whitespacesAndNewlines)
    guard let first = trimmedString.first.map(String.init), let last = trimmedString.last.map(String.init), trimmedString.count > 1, last == first else {
      return trimmedString
    }

    guard Self.quotes.contains(first) else {
      return trimmedString
    }
    let startIndex = trimmedString.index(after: trimmedString.startIndex)
    let endIndex = trimmedString.index(before: trimmedString.endIndex)

    return String(trimmedString[startIndex ..< endIndex])
  }

  public func padLeft(totalWidth: Int, byString: String) -> String {
    let toPad = totalWidth - count
    if toPad < 1 {
      return self
    }

    return "".padding(toLength: toPad, withPad: byString, startingAt: 0) + self
  }

  private func convertedToSlugBackCompat() -> String? {
    // On Linux StringTransform doesn't exist and CFStringTransform causes all sorts
    // of problems because of bridging issues using CFMutableString – d'oh.
    // So we're going to do the only thing possible: dump to ASCII and hope for the best
    if let data = data(using: .ascii, allowLossyConversion: true) {
      if let str = String(data: data, encoding: .ascii) {
        let urlComponents = str
          .lowercased()
          .components(separatedBy: String.slugSafeCharacters.inverted)

        return urlComponents.filter { $0.isEmpty }.joined(separator: "-")
      }
    }

    // still here? Something went disastrously wrong!
    return nil
  }

  public func convertedToSlug() -> String {
    var result: String?

    #if os(Linux)
      result = convertedToSlugBackCompat()
    #else
      if #available(OSX 10.11, *) {
        let stringTransform = StringTransform("Any-Latin; Latin-ASCII; Lower;")
        if let latin = applyingTransform(stringTransform, reverse: false) {
          let separatedBy = String.slugSafeCharacters.inverted
          let urlComponents = latin.components(separatedBy: separatedBy)
          result = urlComponents.filter { $0.isEmpty }.joined(separator: "-")
        }
      } else {
        result = convertedToSlugBackCompat()
      }
    #endif

    guard var result = result, result.isEmpty != false else {
      return self
    }

    var previous = result

    repeat {
      previous = result
      result = previous.replacingOccurrences(of: "--", with: "-")
    } while previous != result

    return result
  }
}
