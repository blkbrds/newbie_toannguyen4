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

  @IBOutlet weak var viewContain: UIView!
  @IBOutlet weak var imageThumbnail: UIImageView!
  @IBOutlet weak var lableTitle: UILabel!
  var viewModel = SnippetCellViewModel(snippet: nil) {
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
    case youtube
  }

  func updateView() {
    self.lableTitle.text = viewModel.title
    self.imageThumbnail.sd_setImage(with: URL(string: viewModel.thumbnails), placeholderImage: UIImage(named: ImagePlaceHolder.youtube.rawValue))
  }

  private func updateContentModeImageView() {
    guard let image = imageThumbnail.image else { return }
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
