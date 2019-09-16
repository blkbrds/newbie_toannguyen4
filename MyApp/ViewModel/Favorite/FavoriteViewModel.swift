//
//  FavoriteViewModel.swift
//  MyApp
//
//  Created by Toan Nguyen D. [4] on 9/9/19.
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
  private let realmError: String = "Error when write Realm"

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

  func fetchDataFavorite() -> Results<Favorite>? {
    do {
      return try Realm().objects(Favorite.self)
    } catch {
      return nil
    }
  }

  // MARK: - Action
  func fetchAllFavorite() {
    guard favorites == nil else { return }
    do {
      favorites = try Realm().objects(Favorite.self)
    } catch {
      favorites = nil
    }
    token = favorites?.observe({ [weak self] (change) in
      guard let this = self else { return }
      this.notify(change: change)
    })
  }

  func addDataFavorite(json: Favorite, completion: @escaping (RealmError?) -> Void) {
    //insert data to realm
    DispatchQueue.main.async {
      do {
        let realm = try Realm()
        try realm.write {
            realm.add(json)
        }
      } catch {
        completion(.error(self.realmError))
      }
    }
  }

  func deleteDataFavorite(id: String, completion: @escaping (RealmError?) -> Void) {
    //insert data to realm
    DispatchQueue.main.async {
      do {
        let realm = try Realm()
        try realm.write {
          if let videoId = try Realm().object(ofType: Favorite.self, forPrimaryKey: id) {
            realm.delete(videoId)
          }
        }
      } catch {
        completion(.error(self.realmError))
      }
    }
  }

  func isExistFavoriteItem(videoId: String) -> Bool {
    do {
      return try Realm().object(ofType: Favorite.self, forPrimaryKey: videoId) != nil
    } catch {
      return false
    }
  }
}
