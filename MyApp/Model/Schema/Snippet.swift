//
//  Snippet.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

import Foundation
import RealmSwift
import ObjectMapper
import Realm

final class Snippet: Object, Mappable {
  required convenience init?(map: Map) {
    self.init()
  }

  @objc dynamic var publishedAt = ""
  @objc dynamic var channelId = ""
  @objc dynamic var title = ""
  @objc dynamic var des = ""
  //@objc dynamic var thumbnails = ["":""]
  @objc dynamic var channelTitle = ""
  @objc dynamic var liveBroadcastContent = ""

  typealias JSON = [String: Any]
  //let snippets = List<Snippet>()

  convenience init(json: JSON) {
    var schema: [String: Any] = [:]
    if let publishedAt = json["publishedAt"] {
      schema["publishedAt"] = publishedAt
    }
    if let channelId = json["channelId"] {
      schema["channelId"] = channelId
    }
    if let title = json["title"] {
      schema["title"] = title
    }
    if let description = json["description"] {
      schema["description"] = description
    }
    if let channelTitle = json["channelTitle"] {
      schema["channelTitle"] = channelTitle
    }
    if let liveBroadcastContent = json["liveBroadcastContent"] {
      schema["liveBroadcastContent"] = liveBroadcastContent
    }
    self.init(value: schema)
  }

  func mapping(map: Map) {
    publishedAt <- map["publishedAt"]
    channelId <- map["channelId"]
    title <- map["title"]
    des <- map["description"]
    //thumbnails <- map["thumbnails"]
    channelTitle <- map["channelTitle"]
    liveBroadcastContent <- map["liveBroadcastContent"]
  }

}
