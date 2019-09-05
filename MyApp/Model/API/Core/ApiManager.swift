//
//  ApiManager.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire

typealias JSObject = [String: Any]
typealias JSArray = [JSObject]


struct ApiManager {
  struct Path {
    static let baseURL = "https://www.googleapis.com/youtube"
    static let search = "/v3/search?"
  }

  struct Key {
    static let keyID = "AIzaSyDzfgQXDhXWMwgIhTiQDD7r5PAvPGXETRg"
  }

  struct Snippet {}

}
