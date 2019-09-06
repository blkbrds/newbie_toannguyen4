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

  @objc dynamic var videoId = ""
  @objc dynamic var publishedAt = ""
  @objc dynamic var channelId = ""
  @objc dynamic var title = ""
  @objc dynamic var des = ""
  @objc dynamic var thumbnails = ""
  @objc dynamic var channelTitle = ""
  @objc dynamic var liveBroadcastContent = ""
  @objc dynamic var isFavorite = ""

  convenience init(json: JSObject) {
    var schema: [String: Any] = [:]
    if let video: JSObject = json["id"] as? JSObject {
      if let id = video["videoId"] as? String {
        schema["videoId"] = id
      }
    }

    if let snippet: JSObject = json["snippet"] as? JSObject {
      if let publishedAt = snippet["publishedAt"] {
        schema["publishedAt"] = publishedAt
      }
      if let channelId = snippet["channelId"] {
        schema["channelId"] = channelId
      }
      if let title = snippet["title"] {
        schema["title"] = title
      }
      if let defaultUrl = snippet["thumbnails"] as? JSObject {
        if let thumb = defaultUrl["medium"] as? JSObject {
          if let thumbUrl = thumb["url"] {
            schema["thumbnails"] = thumbUrl
          }
        }
      }
      if let description = snippet["description"] {
        schema["des"] = description
      }
      if let channelTitle = snippet["channelTitle"] {
        schema["channelTitle"] = channelTitle
      }
      if let liveBroadcastContent = snippet["liveBroadcastContent"] {
        schema["liveBroadcastContent"] = liveBroadcastContent
      }
    }

    schema["isFavorite"] = "1"

    self.init(value: schema)
  }

  func mapping(map: Map) {
    videoId <- map["videoId"]
    publishedAt <- map["publishedAt"]
    channelId <- map["channelId"]
    title <- map["title"]
    des <- map["description"]
    thumbnails <- map["thumbnails"]
    channelTitle <- map["channelTitle"]
    liveBroadcastContent <- map["liveBroadcastContent"]
    isFavorite <- map["isFavorite"]
  }
}
