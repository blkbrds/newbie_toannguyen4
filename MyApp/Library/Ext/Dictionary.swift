//
//  Dictionary.swift
//  MyApp
//
//  Created by Toan Nguyen D. [4] on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

extension Dictionary {
  mutating func updateValues(_ info: [Key: Value]?) {
    guard let info = info else { return }
    for (key, value) in info {
      self[key] = value
    }
  }
}
