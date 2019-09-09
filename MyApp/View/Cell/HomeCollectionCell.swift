//
//  HomeCollectionCell.swift
//  MyApp
//
//  Created by MBA0103 on 8/30/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM
import SDWebImage
import SwiftDate
import CoreImage

class HomeCollectionCell: UICollectionViewCell, MVVM.View {

  @IBOutlet weak var thumbnailImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var favoriteImage: UIImageView!
  @IBOutlet weak var containView: UIView!
  var viewModel: SnippetCellViewModel? {
    didSet {
      updateView()
    }
  }
  var image: UIImage? {
    didSet {
      updateContentModeImageView()
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
    self.thumbnailImage.sd_setImage(with: URL(string: viewModel.thumbnails), placeholderImage: UIImage(named: ImagePlaceHolder.youtube.rawValue))
  }

  private func updateContentModeImageView() {
    guard let image = thumbnailImage.image else { return }
    let viewAspectRatio = self.bounds.width / self.bounds.height
    let imageAspectRatio = image.size.width / image.size.height
    if viewAspectRatio > imageAspectRatio {
      self.contentMode = .scaleAspectFill
    } else {
      self.contentMode = .scaleAspectFit
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    updateContentModeImageView()
  }
}
