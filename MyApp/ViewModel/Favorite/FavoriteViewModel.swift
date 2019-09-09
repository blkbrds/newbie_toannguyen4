//
//  FavoriteViewModel.swift
//  MyApp
//
//  Created by MBA0103 on 9/9/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import MVVM
import SwiftyJSON

class FavoriteViewModel: MVVM.ViewModel {

  weak var delegate: ViewModelDelegate?

  func addDataFavorite(json: Favorite) {
    //insert data to realm
    DispatchQueue.main.async {
      do {
        let realm = try Realm()
        try realm.write {
            realm.add(json)
        }
      } catch {
        print("Error with Realm")
      }
    }
  }
}

