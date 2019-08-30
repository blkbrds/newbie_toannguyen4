import Foundation

final class Api {
  struct Path {
    static let baseURL = "https://www.googleapis.com/youtube"
  }
  // MARK: - Services properties define
  struct Downloader {}

  struct Snippet {
    var id: Int
  }
}

extension Api.Path {
  struct Snippet: ApiPath {
    static var path: String { return baseURL / "v3/search?" }
    let token: String
    let keySearch: String
    let keyID: String
    var urlString: String { return Snippet.path / "pageToken=\(token)&part=snippet&maxResults=50&order=relevance&q=\(keySearch)&key=\(keyID)" }
  }
}

protocol URLStringConvertible {
  var urlString: String { get }
}

protocol ApiPath: URLStringConvertible {
  static var path: String { get }
}

extension URL: URLStringConvertible {
  var urlString: String { return absoluteString }
}

extension Int: URLStringConvertible {
  var urlString: String { return String(describing: self) }
}

fileprivate func / (lhs: URLStringConvertible, rhs: URLStringConvertible) -> String {
  return lhs.urlString + "/" + rhs.urlString
}

extension String: URLStringConvertible {
  var urlString: String { return self }
}

extension CustomStringConvertible where Self: URLStringConvertible {
  var urlString: String { return description }
}
