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

  private var snippets: Results<Snippet>?
  private var token: NotificationToken?

  func numberOfSections() -> Int {
    guard let _ = snippets else {
      return 0
    }
    return 1
  }

  func numberOfItems(inSection section: Int) -> Int {
    guard let snippets = snippets else {
      return 0
    }
    return snippets.count
  }

  func viewModelForItem(at indexPath: IndexPath) -> SnippetCellViewModel {
    guard let snippets = snippets else {
      fatalError("Please call `fetch()` first.")
    }
    let snippet = snippets[indexPath.row]
    return SnippetCellViewModel(snippet: snippet)
  }

  // MARK: - Action

  func fetch() {
    guard snippets == nil else { return }
    do {
      try snippets = Realm().objects(Snippet.self)
    } catch {
      snippets = nil
    }
    token = snippets?.observe({ [weak self] (change) in
      guard let this = self else { return }
      this.notify(change: change)
    })
  }

  enum SnippetResult {
    case success
    case failure
  }

  typealias GetSnippetCompletion = (SnippetResult) -> Void

  func getSnippets(keySearch: String, completion: @escaping GetSnippetCompletion) {
    let params = Api.Snippet.QueryParams(
      token: "CBkQAA",
      keyID: "AIzaSyDIJ9UssMoN9IfR9KnTc4lb3B9NtHpRF-c"
    )

    Api.Snippet.query(keySearch: keySearch, params: params) { (result) in
      do {
        try Realm().refresh()
      } catch {
        print("can not refresh")
      }

      switch result {
      case .success(let data):
        if let dict = data as? JSObject {
          guard let items = dict["items"] as? JSArray else {
            return
          }

          DispatchQueue.main.async {
            do {
              let realm = try Realm()
              try realm.write {
                realm.deleteAll()
                for item in items {
                  guard let snippet = item["snippet"] as? JSObject else {
                    return
                  }
                  realm.add(Snippet(json: snippet))
                }
              }
            } catch {
              print("Error with Realm")
            }
          }
        } else {
          print("It's not")
        }
        completion(.success)
      case .failure(_):
        completion(.failure)
      }
    }
  }
}
