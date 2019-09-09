//
//  FavoriteCellViewModel.swift
//  MyApp
//
//  Created by MBA0103 on 9/9/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class FavoriteCellViewModel: MVVM.ViewModel {

  let publishedAt: String
  let channelId: String
  let title: String
  let des: String
  let thumbnails: String
  let channelTitle: String
  let liveBroadcastContent: String
  let videoId: String

  init(snippet: Snippet) {
    videoId = snippet.videoId
    publishedAt = snippet.publishedAt
    channelId = snippet.channelId
    title = snippet.title
    des = snippet.des
    thumbnails = snippet.thumbnails
    channelTitle = snippet.channelTitle
    liveBroadcastContent = snippet.liveBroadcastContent
  }
}
