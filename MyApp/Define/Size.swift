//
//  Size.swift
//  MyApp
//
//  Created by MBA0103 on 9/4/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

extension App {
  struct SizeHomeTableViewCell {
    static let kHeightCellSection: CGFloat = 130
  }

  struct SizeHeaderSection {
    static let kHeightHeaderSection: CGFloat = 210
  }

  struct SizeHomeCollectionViewCell {
    static let kWidthScreen: CGFloat = UIScreen.main.bounds.width
    static let kWidthHeaderSection: CGFloat = kWidthScreen
    static let kMarginLeft: CGFloat = 10
    static let kMarginRight: CGFloat = 5
    static let kCellWidth: CGFloat = (kWidthScreen / 2) - kMarginLeft - kMarginRight
    static var kCellheight: CGFloat = kWidthScreen / 2
    static let kWidthPerItem: CGFloat = 10
    static let kCellInsets = UIEdgeInsets(top: 5.0,
                                          left: 10.0,
                                          bottom: 0.0,
                                          right: 10.0)
    static let kHeaderInsets = UIEdgeInsets.zero
  }

  struct SizeSearchBar {
    static let kHeightShowSearchBar: CGFloat = 44
    static let kHeightHiddenSearchBar: CGFloat = .zero
  }

  struct SizeRightIconNavi {
    static let kWidth: CGFloat = 30
    static let kHeigh: CGFloat = 30
  }

  struct SizeMap {
    static let lineWidth: CGFloat = 3
    static let lineDashPhase: CGFloat = 10
  }
}
