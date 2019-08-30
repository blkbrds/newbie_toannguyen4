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

  var publishedAt = ""
  var channelId = ""
  var title = ""
  var des = ""
  var thumbnails = ""
  var channelTitle = ""
  var liveBroadcastContent = ""

  init(snippet: Snippet?) {
    guard let snippet = snippet else { return }
    publishedAt = snippet.publishedAt
    channelId = snippet.channelId
    title = snippet.title
    des = snippet.des
    thumbnails = snippet.thumbnails
    channelTitle = snippet.channelTitle
    liveBroadcastContent = snippet.liveBroadcastContent
  }
}
