//
//  YoutubeCell.swift
//  MyApp
//
//  Created by Toan Nguyen D. [4] on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM
import SDWebImage
import SwiftDate

class YoutubeCell: UITableViewCell, MVVM.View {
  @IBOutlet weak var thumbnailImage: ImageView!
  @IBOutlet weak var titleLabel: Label!
  @IBOutlet weak var chanelLabel: Label!
  @IBOutlet weak var favoriteButton: Button!
  private let favoriteViewModel = FavoriteViewModel()
  var viewModel: SnippetCellViewModel? {
    didSet {
      updateView()
    }
  }

  var favoriteCellViewModel: FavoriteCellViewModel? {
    didSet {
      updateViewFavorite()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    updateView()
  }

  enum ImagePlaceHolder: String {
    case youtube = "img-youtube"
  }

  enum IconFavorite: String {
    case active = "ic-favoriteActive"
    case inActive = "ic-favoriteInActive"
  }

  func updateView() {
    guard let viewModel = viewModel else {
      return
    }

    if favoriteViewModel.isExistFavoriteItem(videoId: viewModel.videoId) {
      self.favoriteButton.setImage(UIImage(named: IconFavorite.active.rawValue), for: .normal)
    } else {
      self.favoriteButton.setImage(UIImage(named: IconFavorite.inActive.rawValue), for: .normal)
    }
    self.titleLabel.text = viewModel.title
    self.chanelLabel.text = viewModel.channelTitle
    self.thumbnailImage.sd_setImage(with: URL(string: viewModel.thumbnails), placeholderImage: UIImage(named: ImagePlaceHolder.youtube.rawValue))
  }

  func updateViewFavorite() {
    guard let viewModel = favoriteCellViewModel else {
      return
    }
    self.favoriteButton.isHidden = true
    self.titleLabel.text = viewModel.title
    self.chanelLabel.text = viewModel.channelTitle
    self.thumbnailImage.sd_setImage(with: URL(string: viewModel.thumbnails), placeholderImage: UIImage(named: ImagePlaceHolder.youtube.rawValue))
  }
}
