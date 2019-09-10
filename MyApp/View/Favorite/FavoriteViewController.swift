//
//  FavoriteViewController.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import MVVM

final class FavoriteViewController: UIViewController {
  @IBOutlet weak var tableView: TableView!
  private var favoriteViewModel = FavoriteViewModel()
  private var itemsToken: NotificationToken?
  enum IdentifierNib {
    static let youtubeCell: String = "YoutubeCell"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Favorite"
    registerNib()
    favoriteViewModel.fetchAllFavorite()
  }

  private func registerNib() {
    //register tableview
    tableView.register(UINib(nibName: IdentifierNib.youtubeCell, bundle: nil), forCellReuseIdentifier: IdentifierNib.youtubeCell)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = App.SizeHomeTableViewCell.kHeightCellSection
    tableView.reloadData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    itemsToken = favoriteViewModel.fetchAllFavorite().observe { [weak tableView] changes in
      guard let tableView = tableView else { return }

      switch changes {
      case .initial:
        tableView.reloadData()
      case .update(_, let deletions, let insertions, let updates):
        tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
      case .error: break
      }
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    itemsToken?.invalidate()
  }
}

extension FavoriteViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return favoriteViewModel.numberOfSections()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favoriteViewModel.numberOfItems(inSection: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierNib.youtubeCell) as? YoutubeCell
      else { fatalError() }
    cell.favoriteCellViewModel = favoriteViewModel.viewModelForItems(at: indexPath)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return App.SizeHomeTableViewCell.kHeightCellSection
  }
}
