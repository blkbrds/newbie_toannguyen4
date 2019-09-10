//
//  API.Snippet.swift
//  MyApp
//
//  Created by Toan Nguyen D. [4] on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import Realm
import RealmSwift

extension ApiManager.Snippet {
  struct QueryString {

    func getSnippet(searchKey: String, params: ApiManager.Snippet.QueryParams) -> String {
      return ApiManager.Path.baseURL + ApiManager.Path.search + "/pageToken=\(params.pageToken)&part=snippet&maxResults=\(params.maxResults)&order=relevance&q=\(searchKey)&key=\(params.keyID)"
    }
  }

  struct SnippetResult {
    var snippets: [Snippet]
    var pageNextToken: String
  }

  struct QueryParams {
    let pageToken: String
    let maxResults: Int
    let keyID: String
  }

  static func getSnippet(searchKey: String, params: ApiManager.Snippet.QueryParams, completion: @escaping APICompletion<SnippetResult>) {
    let urlString = QueryString().getSnippet(searchKey: searchKey, params: params)

    API.shared().request(urlString: urlString) { (result) in
      switch result {
      case .failure(let error):
        completion(.failure(error))
      case .success(let data):
        if let data = data {
          let json = data.convertToJSON()
          guard let items = json["items"] as? JSArray else {
            completion(.failure(.error("Item not found")))
            return
          }
          var snippets = [Snippet]()
          for item in items {
            let snip = Snippet(json: item)
            snippets.append(snip)
          }
          guard let nextPageToken = json["nextPageToken"] as? String else {
            return
          }
          completion(.success(SnippetResult(snippets: snippets, pageNextToken: nextPageToken)))
        } else {
          //handle error
          completion(.failure(.error("Data format wrong!")))
        }
      }
    }
  }
}
