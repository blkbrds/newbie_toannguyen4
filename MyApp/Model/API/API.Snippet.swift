//
//  API.Snippet.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import Realm
import RealmSwift

extension Api.Snippet {
  struct QueryParams {
    let token: String
    let keyID: String
  }

  @discardableResult
  static func query(keySearch: String, params: Api.Snippet.QueryParams, completion: @escaping Completion) -> Request? {
    let path = Api.Path.Snippet(token: params.token, keySearch: keySearch, keyID: params.keyID)
    return api.request(method: .get, urlString: path) { (result) in
      Mapper<Snippet>().map(result: result, type: .object, completion: { (result) in
        DispatchQueue.main.async {
          completion(result)
        }
      })
    }
  }
}
