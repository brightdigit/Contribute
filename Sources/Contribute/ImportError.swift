import Foundation

@available(*, deprecated)
public enum ImportError: Error {
  case directory(URL)
  case imageDownloads([URL: Error])
  case assetDownloads([URL: Error])
  case invalidPodcastEpisodeFromRSSItem(Any)
  case invalidRSS(URL)
  case apiError(Error)
  case missingResponseFromPlaylistID(String, ResponseComponent)
  case unknownError(Error)
  case missingFieldForVideo(Any, VideoField)
  case missingVideoForEpisode(Any)
  case missingFieldFromPodcastEpisode(Any, EpisodeField)
  case duplicateTitle(String, forVideos: [Any])
  case invalidMailchimp
  case newsletterMissingField(NewsletterField)
  case missingHTMLForCampaignID(String)

  public enum ResponseComponent {
    case anyResponse
    case success
    case items
  }

  public enum VideoField {
    case snippetTitle
    case id
    case duration
    case description
  }

  public enum EpisodeField {
    case duration
    case title
    case episode
    case summary
    case imageHref
  }

  public enum NewsletterField {
    case id
    case longArchiveURL
    case title
    case subjectLine
    case sendTime
  }
}
