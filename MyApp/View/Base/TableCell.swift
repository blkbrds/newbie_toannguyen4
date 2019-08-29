//
//  TableCell.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class TableCell: UITableViewCell, MVVM.View {
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
    textLabel?.text = viewModel.title
    detailTextLabel?.text = viewModel.des
  }
}
