import Foundation

// Defines
enum APIError: Error {
  case error(String)
  case errorURL

  var localizedDescription: String {
    switch self {
    case .error(let string):
      return string
    case .errorURL:
      return "URL String is error."
    }
  }
}

typealias APICompletion<T> = (Result<T, APIError>) -> Void

enum APIResult {
  case success(Data?)
  case failure(APIError)
}

//define error with realm
enum RealmError {
  case error(String)
  case errorWriteReal

  var localizedDescription: String {
    switch self {
    case .error(let string):
      return string
    case .errorWriteReal:
      return "Can't open realm"
    }
  }
}

struct API {
  //singleton
  private static var shareAPI: API = {
    let shareAPI = API()
    return shareAPI
  }()

  static func shared() -> API {
    return shareAPI
  }

  //init
  private init() {}
}
