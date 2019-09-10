//
//  ResultExt.swift
//  MyApp
//
//  Created by Toan Nguyen D. [4] on 9/4/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

extension Results {
  func toArray<T>(type: T.Type) -> [T] {
    return compactMap { $0 as? T }
  }
}
