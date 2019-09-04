//
//  Size.swift
//  MyApp
//
//  Created by MBA0103 on 9/4/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

extension App {
  struct SizeHomeTableViewCell {
      static let kHeightHeaderSection = CGFloat(210.0)
      static let kHeightCellSection = CGFloat(130.0)
  }

  struct SizeHomeCollectionViewCell {
    static let kWidthScreen = CGFloat(UIScreen.main.bounds.width)
    static let kWidthHeaderSection = kWidthScreen
    static let kHeightHeaderSection = CGFloat(210.0)
    static let kMarginLeft = CGFloat(10.0)
    static let kMarginRight = CGFloat(5.0)
    static let kCellWidth = (kWidthScreen / 2) - kMarginLeft - kMarginRight
    static var kCellheight = kWidthScreen / 2
    static let kWidthPerItem = CGFloat(10.0)
    static let kCellInsets = UIEdgeInsets(top: 5.0,
                                             left: 10.0,
                                             bottom: 0,
                                             right: 10.0)
    static let kHeaderInsets = UIEdgeInsets(top: 0.0,
                                          left: 0.0,
                                          bottom: 0.0,
                                          right: 0.0)
  }

  struct SizeSearchBar {
      static let kHeightShowSearchBar = CGFloat(44.0)
      static let kHeightHiddenSearchBar = CGFloat(0.0)
  }

  struct SizeRightIconNavi {
      static let kWidth = CGFloat(30.0)
      static let kHeigh = CGFloat(30.0)
  }
}
