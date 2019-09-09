//
//  SnippetListViewModel.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
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
    //self.snippetList.removeAll()
    let params = ApiManager.Snippet.QueryParams(
      pageToken: pageToken,
      maxResults: 30,
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

        self.insertDataToRealm(json: snippetResult.snippets)
        self.pageToken = snippetResult.pageNextToken
        completion(nil)
      }
    }
  }

  func insertDataToRealm(json: [Snippet]) {
    //insert data to realm
    DispatchQueue.main.async {
      do {
        let realm = try Realm()
        try realm.write {
          realm.deleteAll()
          for item in json {
            realm.add(item)
          }
        }
      } catch {
        print("Error with Realm")
      }
    }
  }
}
