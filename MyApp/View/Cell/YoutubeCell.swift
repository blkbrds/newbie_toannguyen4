//
//  YoutubeCell.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

class YoutubeCell: UITableViewCell, MVVM.View {
  @IBOutlet weak var imageThumbnail: UIImageView!
  @IBOutlet weak var labelTitle: UILabel!
  @IBOutlet weak var labelDesc: UILabel!
  @IBOutlet weak var labelChanel: UILabel!
  @IBOutlet weak var imageFavorite: UIImageView!
  
  var viewModel = SnippetCellViewModel(snippet: nil) {
    didSet {
      updateView()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    updateView()
  }

  func updateView() {
    self.labelTitle.text = viewModel.title
    self.labelDesc.text = viewModel.des
  }
}
