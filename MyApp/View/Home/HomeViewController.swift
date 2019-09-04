//
//  HomeViewController.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import  MVVM
import Realm
import RealmSwift

class HomeViewController: UIViewController, UIScrollViewDelegate, MVVM.View {
  enum SectionTableView: Int {
    case kHeaderSection = 0
    case kYoutubeSection
  }

  enum IconRightNavigation: String {
    case table
    case collection
  }

  var viewModel = SnippetListViewModel() {
    didSet {
      updateView()
    }
  }

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var heightSearchBar: NSLayoutConstraint!
  private var refreshControl = UIRefreshControl()
  private var isDisplayTable = true
  private var keySearch = "IOS"
  private let kMarginLeft = CGFloat(10.0)
  private let kMarginRight = CGFloat(5.0)
  private let kCellWidth = CGFloat(UIScreen.main.bounds.width / 2)
  private var kCellheight = CGFloat(0)
  private let kWidthPerItem = CGFloat(10.0)
  private let sectionInsets = UIEdgeInsets(top: 0.0,
                                           left: 10.0,
                                           bottom: 0,
                                           right: 10.0)
  

  override func viewDidLoad() {
    super.viewDidLoad()
    registerNib()
    changeTypeDisplay()
    fetchDataFromAPI()
    viewModel.fetch()
    setupTitleNavi()
    // Refresh control add in tableview.
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    tableView.addSubview(refreshControl)
  }

  func fetchDataFromAPI() {
    viewModel.getSnippets(keySearch: self.keySearch) { [weak self] (result) in
      guard let this = self else { return }
      switch result {
      case .success:
        self?.updateView()
      case .failure:
        this.alert(error: "Can't load data!")
      }
      this.viewDidUpdated()
    }
  }

  @objc func refresh(_ sender: Any) {
    DispatchQueue.main.async {
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
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
    tableView.estimatedRowHeight = 120
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

    rightIcon.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
    rightIcon.addTarget(self, action: #selector(changeTypeDisplay), for: .touchUpInside)
    let barButtonItem = UIBarButtonItem(customView: rightIcon)

    self.navigationItem.rightBarButtonItem = barButtonItem
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 {
      self.heightSearchBar.constant = 44
    } else {
      self.heightSearchBar.constant = 0
    }
  }

  @objc func changeTypeDisplay() {
    setupRightNavigationItem()

    if isDisplayTable {
      isDisplayTable = false
      tableView.isHidden = false
      collectionView.isHidden = true
    } else {
      isDisplayTable = true
      tableView.isHidden = true
      collectionView.isHidden = false
    }
  }
}

extension HomeViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.getSnippets(keySearch: searchText) { [weak self] (result) in
      guard let this = self else { return }
      switch result {
      case .success:
        self?.updateView()
      case .failure:
        this.alert(error: "Can't load data!")
      }
      this.viewDidUpdated()
    }
    viewModel.fetch()
    updateView()
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
    fetchDataFromAPI()
    updateView()
  }
}

extension HomeViewController: ViewModelDelegate {
  func viewModel(_ viewModel: ViewModel, didChangeItemsAt indexPaths: [IndexPath], changeType: ChangeType) {
    updateView()
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
    cell.viewModel = viewModel.viewModelForItem(at: indexPath)
    return cell
  }
}
// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print(viewModel.viewModelForItem(at: indexPath).title)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == SectionTableView.kHeaderSection.rawValue {
      return 210
    }

    return 130
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    // 1
    let shareAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
      self.viewModel.delete(index: indexPath.row, completion: { (result) in
        switch result {
        case .success:
          self.viewModel.fetch()
          tableView.reloadData()
          print("Delete completed!")
        case .failure:
          print("Delete faild")
        }
      })
    })
    return [shareAction]
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
      return CGSize(width: kCellWidth * 2, height: 210)
    }
    return CGSize(width: (kCellWidth - kMarginLeft - kMarginRight), height: kCellWidth - 30)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if section == SectionTableView.kHeaderSection.rawValue {
      return UIEdgeInsets(top: 5.0,
                          left: 0.0,
                          bottom: 0,
                          right: 0.0)
    }
    return sectionInsets.self
  }
}
