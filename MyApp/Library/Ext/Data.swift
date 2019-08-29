//
//  Data.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

extension Data {
  func toJSON() -> Any? {
    do {
      return try JSONSerialization.jsonObject(
        with: self,
        options: JSONSerialization.ReadingOptions.allowFragments
      )
    } catch {
      return nil
    }
  }
  func toString() -> String? {
    return String(data: self, encoding: .utf8)
  }
}
