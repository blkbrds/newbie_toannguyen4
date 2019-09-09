//
//  Color.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

/**
 This file defines all colors which are used in this application.
 Please navigate by the control as prefix.
 */

import UIKit

extension App {
    struct Color {
        static let navigationBar = UIColor.black
        static let tableHeaderView = UIColor.gray
        static let tableFooterView = UIColor.red
        static let tableCellTextLabel = UIColor.yellow
        static let mapFillColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 0.3)
        static let mapStrokeColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 0.7)
      
        static func button(state: UIControlState) -> UIColor {
            switch state {
            case UIControlState.normal: return .blue
            default: return .gray
            }
        }
    }
}
