//
//  Data.swift
//  MyApp
//
//  Created by Toan Nguyen D. [4] on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

extension Data {
  func convertToJSON() -> [String: Any]? {
    var json: [String: Any] = [:]
    do {
      if let jsonObject = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [String: Any] {
        json = jsonObject
      }
    } catch {
      json = [:]
    }

    return json
  }

  func toString() -> String? {
    return String(data: self, encoding: .utf8)
  }
}
