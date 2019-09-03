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
  @IBOutlet weak var thumbnailImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var chanelLabel: UILabel!
  @IBOutlet weak var favoriteImage: UIImageView!
  var viewModel = SnippetCellViewModel(snippet: nil) {
    didSet {
      updateView()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    updateView()
  }

  enum ImagePlaceHolder: String {
    case youtube
  }

  func updateView() {
    self.titleLabel.text = viewModel.title
    self.chanelLabel.text = viewModel.channelTitle
    self.thumbnailImage.sd_setImage(with: URL(string: viewModel.thumbnails), placeholderImage: UIImage(named: ImagePlaceHolder.youtube.rawValue))
  }
}
