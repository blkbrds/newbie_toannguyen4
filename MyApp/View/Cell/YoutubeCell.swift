//
//  YoutubeCell.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
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
  var viewModel: SnippetCellViewModel? {
    didSet {
      updateView()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    updateView()
  }

  enum ImagePlaceHolder: String {
    case youtube = "img-youtube"
  }

  func updateView() {
    guard let viewModel = viewModel else {
      return
    }
    self.titleLabel.text = viewModel.title
    self.chanelLabel.text = viewModel.channelTitle
    self.thumbnailImage.sd_setImage(with: URL(string: viewModel.thumbnails), placeholderImage: UIImage(named: ImagePlaceHolder.youtube.rawValue))
  }
}
