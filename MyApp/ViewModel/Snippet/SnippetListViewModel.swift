//
//  SnippetListViewModel.swift
//  MyApp
//
//  Created by Toan Nguyen D. [4] on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import MVVM
import SwiftyJSON

class SnippetListViewModel: MVVM.ViewModel {

  weak var delegate: ViewModelDelegate?
  private var snippetList: [Snippet] = []
  private let maximumResults: Int = 30
  private let realmError: String = "Error when write Realm"
  var pageToken: String = ""

  func numberOfSections() -> Int {
    if snippetList.isEmpty {
      return 0
    }
    return 1
  }

  func numberOfItems(inSection section: Int) -> Int {
    if snippetList.isEmpty {
      return 0
    }
    return snippetList.count
  }

  func viewModelForItem(at indexPath: IndexPath) -> SnippetCellViewModel {
    guard let snippet: Snippet = snippetList[indexPath.row] else {
      fatalError("Error with convert data faild")
    }
    return SnippetCellViewModel(snippet: snippet)
  }

  // MARK: - Action

  func fetchData(searchKey: String, completion: @escaping (APIError?) -> Void) {

    let params = ApiManager.Snippet.QueryParams(
      pageToken: pageToken,
      maxResults: maximumResults,
      keyID: ApiManager.Key.keyID
    )
    ApiManager.Snippet.getSnippet(searchKey: searchKey, params: params) { (result) in
      switch result {
      case .failure(let error):
        completion(error)
      case .success(let snippetResult):
        self.snippetList.removeAll()

        for snippet in snippetResult.snippets {
          self.snippetList.append(snippet)
        }
        self.insertDataToRealm(json: snippetResult.snippets,  completion: { (result) in })
        self.pageToken = snippetResult.pageNextToken
        completion(nil)
      }
    }
  }

  func checkValidatePrimaryKey(videoId: String) -> Bool {
    do {
      return try Realm().object(ofType: Snippet.self, forPrimaryKey: videoId) != nil
    } catch {
      return false
    }
  }

  func insertDataToRealm(json: [Snippet], completion: @escaping (RealmError?) -> Void) {
    //insert data to realm
    DispatchQueue.main.async {
      do {
        let realm = try Realm()
        try realm.write {
          let items = realm.objects(Snippet.self)
          realm.delete(items)
          for item in json {
            if !self.checkValidatePrimaryKey(videoId: item.videoId) {
                realm.add(item)
            }
          }
        }
      } catch {
        completion(.error(self.realmError))
      }
    }
  }
}
