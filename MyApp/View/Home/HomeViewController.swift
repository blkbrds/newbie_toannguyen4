//
//  HomeViewController.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM
import Realm
import RealmSwift
import SVProgressHUD

class HomeViewController: UIViewController, UIScrollViewDelegate, MVVM.View {
  enum SectionTableView: Int {
    case kHeaderSection = 0
    case kYoutubeSection
  }

  enum IconRightNavigation: String {
    case table = "ic-table"
    case collection = "ic-collection"
  }

  var viewModel = SnippetListViewModel() {
    didSet {
      updateView()
    }
  }

  var favoriteViewModel = FavoriteViewModel()

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var heightSearchBar: NSLayoutConstraint!
  private var refreshControl = UIRefreshControl()
  private var isDisplayTable = true
  private var keySearch = "IOS13"

  override func viewDidLoad() {
    super.viewDidLoad()
    registerNib()
    changeTypeDisplay()
    setupTitleNavi()
    viewModel.delegate = self
    loadData()
   //
    //viewModel.fetch()
    // Refresh control add in tableview.
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    tableView.addSubview(refreshControl)
  }

  @objc func refresh(_ sender: Any) {
    loadData()
    refreshControl.endRefreshing()
    SVProgressHUD.dismiss()
  }

  func loadData() {
    SVProgressHUD.show()
    self.viewModel.fetchData(searchKey: self.keySearch) { (error) in
      if let error = error {
        SVProgressHUD.dismiss()
        self.alert(error: error.localizedDescription)
      } else {
        //success
        self.updateView()
        SVProgressHUD.dismiss()
      }
    }
  }

  func updateView() {
    guard isViewLoaded else { return }
    if !isDisplayTable {
      tableView.reloadData()
    } else {
      collectionView.reloadData()
    }
    viewDidUpdated()
  }

  func setupTitleNavi() {
    self.navigationItem.title = "Home"
  }

  enum IdentifierNib {
    static let youtubeCell: String = "YoutubeCell"
    static let headerCell: String = "HeaderCell"
    static let homeCollectionCell: String = "HomeCollectionCell"
    static let headerCollectionCell: String = "HeaderCollectionCell"
  }

  private func registerNib() {
    //register tableview
    tableView.register(UINib(nibName: IdentifierNib.youtubeCell, bundle: nil), forCellReuseIdentifier: IdentifierNib.youtubeCell)
    tableView.register(UINib(nibName: IdentifierNib.headerCell, bundle: nil), forCellReuseIdentifier: IdentifierNib.headerCell)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = App.SizeHomeTableViewCell.kHeightCellSection
    tableView.dataSource = self
    tableView.delegate = self
    tableView.reloadData()
    searchBar.delegate = self

    //register collectionView
    let cellNib = UINib(nibName: IdentifierNib.homeCollectionCell, bundle: Bundle.main)
    collectionView.register(cellNib, forCellWithReuseIdentifier: IdentifierNib.homeCollectionCell)
    let cellNibHeader = UINib(nibName: IdentifierNib.headerCollectionCell, bundle: Bundle.main)
    collectionView.register(cellNibHeader, forCellWithReuseIdentifier: IdentifierNib.headerCollectionCell)
    collectionView.reloadData()
  }

  func setupRightNavigationItem() {
    let rightIcon = UIButton(type: .custom)

    switch isDisplayTable {
    case true:
      rightIcon.setImage(UIImage (named: IconRightNavigation.collection.rawValue), for: .normal)
    default:
      rightIcon.setImage(UIImage (named: IconRightNavigation.table.rawValue), for: .normal)
    }

    rightIcon.frame = CGRect(x: 0.0, y: 0.0, width: App.SizeRightIconNavi.kWidth, height: App.SizeRightIconNavi.kHeigh)
    rightIcon.addTarget(self, action: #selector(changeTypeDisplay), for: .touchUpInside)
    let barButtonItem = UIBarButtonItem(customView: rightIcon)

    self.navigationItem.rightBarButtonItem = barButtonItem
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 {
      self.heightSearchBar.constant = App.SizeSearchBar.kHeightShowSearchBar
    } else {
      self.heightSearchBar.constant = App.SizeSearchBar.kHeightHiddenSearchBar
    }
  }

  @objc func changeTypeDisplay() {
    setupRightNavigationItem()

    if isDisplayTable {
      isDisplayTable = false
      tableView.isHidden = false
      collectionView.isHidden = true
    } else {
      //loadData()
      collectionView.reloadData()
      isDisplayTable = true
      tableView.isHidden = true
      collectionView.isHidden = false
    }
  }
}

extension HomeViewController: ViewModelDelegate {
  func viewModel(_ viewModel: ViewModel, didChangeItemsAt indexPaths: [IndexPath], changeType: ChangeType) {
    updateView()
  }
}

extension HomeViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.fetchData(searchKey: searchText) { (error) in
      if let error = error {
        self.alert(error: error.localizedDescription)
      } else {
        self.updateView()
        // success: display data search
      }
    }
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.setShowsCancelButton(false, animated: true)
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setValue("Cancel", forKey: "_cancelButtonText")
    searchBar.setShowsCancelButton(true, animated: true)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.setShowsCancelButton(false, animated: true)
    loadData()
  }
}

extension HomeViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections() + 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == SectionTableView.kHeaderSection.rawValue {
      return 1
    }
    return viewModel.numberOfItems(inSection: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == SectionTableView.kHeaderSection.rawValue {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierNib.headerCell) as? HeaderCell
        else { fatalError() }
      return cell
    }

    guard let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierNib.youtubeCell) as? YoutubeCell
      else { fatalError() }
    cell.favoriteButton.addTarget(self, action: #selector(favoriteTapped(_:)), for: .touchUpInside)
    cell.favoriteButton.tag = indexPath.row
    cell.viewModel = viewModel.viewModelForItem(at: indexPath)
    return cell
  }
  
  @objc func favoriteTapped(_ sender: UIButton)
  {
    let indexPath = IndexPath(row: sender.tag, section: SectionTableView.kYoutubeSection.rawValue)
    let favorite = Favorite()
    let snippet = viewModel.viewModelForItem(at: indexPath)
    favorite.videoId = snippet.videoId
    favorite.publishedAt = snippet.publishedAt
    favorite.channelId = snippet.channelId
    favorite.title = snippet.title
    favorite.des = snippet.des
    favorite.thumbnails = snippet.thumbnails
    favorite.channelTitle = snippet.channelTitle
    favorite.liveBroadcastContent = snippet.liveBroadcastContent
    favoriteViewModel.addDataFavorite(json: favorite)
  }
}
// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print(viewModel.viewModelForItem(at: indexPath).title)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == SectionTableView.kHeaderSection.rawValue {
      return App.SizeHeaderSection.kHeightHeaderSection
    }
    return App.SizeHomeTableViewCell.kHeightCellSection
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    // 1
    if indexPath.section == SectionTableView.kYoutubeSection.rawValue {
      let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
        //delete here

      })
      return [deleteAction]
    }
    return nil
  }
}

extension HomeViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSections() + 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == SectionTableView.kHeaderSection.rawValue {
      return 1
    }
    return viewModel.numberOfItems(inSection: section)
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.section == SectionTableView.kHeaderSection.rawValue {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdentifierNib.headerCollectionCell, for: indexPath) as? HeaderCollectionCell else {
        return UICollectionViewCell()
      }
      return cell
    }

    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdentifierNib.homeCollectionCell, for: indexPath) as? HomeCollectionCell else {
      return UICollectionViewCell()
    }

    cell.viewModel = viewModel.viewModelForItem(at: indexPath)
    return cell
  }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section == SectionTableView.kHeaderSection.rawValue {
      return CGSize(width: App.SizeHomeCollectionViewCell.kWidthHeaderSection, height: App.SizeHeaderSection.kHeightHeaderSection)
    }
    return CGSize(width: App.SizeHomeCollectionViewCell.kCellWidth, height: App.SizeHomeCollectionViewCell.kCellheight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if section == SectionTableView.kHeaderSection.rawValue {
      return App.SizeHomeCollectionViewCell.kHeaderInsets
    }
    return App.SizeHomeCollectionViewCell.kCellInsets
  }
}
