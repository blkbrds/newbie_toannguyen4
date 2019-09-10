//
//  Favorite.swift
//  MyApp
//
//  Created by Toan Nguyen D. [4] on 9/9/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import Realm

final class Favorite: Object, Mappable {
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

  override static func primaryKey() -> String? {
    return "videoId"
  }

  convenience init(json: JSObject) {
    var schema: [String: Any] = [:]
    if let snippet = json["snippet"] as? JSObject {
      if let publishedAt = snippet["publishedAt"] {
        schema["publishedAt"] = publishedAt
      }
      if let channelId = snippet["channelId"] {
        schema["channelId"] = channelId
      }
      if let title = snippet["title"] {
        schema["title"] = title
      }
      if let description = snippet["description"] {
        schema["des"] = description
      }
      if let channelTitle = snippet["channelTitle"] {
        schema["channelTitle"] = channelTitle
      }
      if let defaultUrl = snippet["thumbnails"] as? JSObject {
        if let thumb = defaultUrl["medium"] as? JSObject {
          if let thumbUrl = thumb["url"] as? String{
            schema["thumbnails"] = thumbUrl
          }
        }
      }
      if let liveBroadcastContent = snippet["liveBroadcastContent"] {
        schema["liveBroadcastContent"] = liveBroadcastContent
      }
    }

    if let video = json["id"] as? JSObject {
      if let iD = video["videoId"] {
        schema["videoId"] = iD
      }
    }

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
  }
}

