//
//  FavoriteCellViewModel.swift
//  MyApp
//
//  Created by Toan Nguyen D. [4] on 9/9/19.
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

  init(favorite: Favorite) {
    videoId = favorite.videoId
    publishedAt = favorite.publishedAt
    channelId = favorite.channelId
    title = favorite.title
    des = favorite.des
    thumbnails = favorite.thumbnails
    channelTitle = favorite.channelTitle
    liveBroadcastContent = favorite.liveBroadcastContent
  }
}
