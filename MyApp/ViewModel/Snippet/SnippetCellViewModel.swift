//
//  SnippetCellViewModel.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class SnippetCellViewModel: MVVM.ViewModel {

  let publishedAt: String
  let channelId: String
  let title: String
  let des: String
  let thumbnails: String
  let channelTitle: String
  let liveBroadcastContent: String

  init(snippet: Snippet) {
    publishedAt = snippet.publishedAt
    channelId = snippet.channelId
    title = snippet.title
    des = snippet.des
    thumbnails = snippet.thumbnails
    channelTitle = snippet.channelTitle
    liveBroadcastContent = snippet.liveBroadcastContent
  }
}
