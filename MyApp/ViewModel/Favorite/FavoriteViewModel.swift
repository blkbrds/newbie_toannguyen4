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
  private var favorites: Results<Favorite>?
  private var token: NotificationToken?

  func numberOfSections() -> Int {
    guard let _ = favorites else {
      return 0
    }
    return 1
  }

  func numberOfItems(inSection section: Int) -> Int {
    guard let favorites = favorites else {
      return 0
    }
    return favorites.count
  }

  func viewModelForItems(at indexPath: IndexPath) -> FavoriteCellViewModel {
    guard let favorites = favorites else {
      fatalError("Please call `fetch()` first.")
    }
    let favorite = favorites[indexPath.row]
    return FavoriteCellViewModel(favorite: favorite)
  }

  func fetchAllFavorite(in realm: Realm = try! Realm()) -> Results<Favorite> {
    return realm.objects(Favorite.self)
  }

  // MARK: - Action
  func fetchAllFavorite() {
    guard favorites == nil else { return }
    favorites = try! Realm().objects(Favorite.self)
    token = favorites?.observe({ [weak self] (change) in
      guard let this = self else { return }
      this.notify(change: change)
    })
  }

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

  func deleteDataFavorite(id: String) {
    //insert data to realm
    DispatchQueue.main.async {
      do {
        let realm = try Realm()
        try realm.write {
          realm.delete(try! Realm().object(ofType: Favorite.self, forPrimaryKey: id)!)
        }
      } catch {
        print("Error with Realm")
      }
    }
  }

  func isExistFavoriteItem(videoId: String) -> Bool {
    return try! Realm().object(ofType: Favorite.self, forPrimaryKey: videoId) != nil
  }
}

