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

  var viewModel = SnippetListViewModel() {
    didSet {
      updateView()
    }
  }

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var heightSearchBar: NSLayoutConstraint!
  private var snippetList: Results<Snippet>?
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
    setupRemainingNavItems(icon: "table")
    setupTableView()
    setupCollectionView()
    changeTypeDisplay()
    viewModel.delegate = self
    viewModel.fetch()
    setupTitleNavi()
    self.fetchSnippet()
    // Refresh control add in tableview.
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    tableView.addSubview(refreshControl)
    //collectionView.addSubview(refreshControl)
  }

  @objc func refresh(_ sender: Any) {
    DispatchQueue.main.async {
      self.tableView.reloadData()
      //self.collectionView.reloadData()
      self.refreshControl.endRefreshing()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    viewModel.getSnippets(keySearch: self.keySearch) { [weak self] (result) in
      guard let this = self else { return }
      switch result {
      case .success:
        self!.tableView.reloadData()
      case .failure:
        this.alert(error: "Can't load data!")
      }
      this.viewDidUpdated()
    }
  }

  func updateView() {
    guard isViewLoaded else { return }
    tableView.reloadData()
    viewDidUpdated()
  }

  func setupTitleNavi() {
    self.navigationItem.title = "Home"
  }

  private func setupTableView() {
    tableView.register(UINib(nibName: "YoutubeCell", bundle: nil), forCellReuseIdentifier: "YoutubeCell")
    tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    tableView.dataSource = self
    tableView.delegate = self
    tableView.reloadData()
    searchBar.delegate = self
  }

  func setupCollectionView() {
    let cellNib = UINib(nibName: "HomeCollectionCell", bundle: Bundle.main)
    collectionView.register(cellNib, forCellWithReuseIdentifier: "HomeCollectionCell")
    let cellNibHeader = UINib(nibName: "HeaderCollectionCell", bundle: Bundle.main)
    collectionView.register(cellNibHeader, forCellWithReuseIdentifier: "HeaderCollectionCell")
    collectionView.reloadData()
  }

  func setupRemainingNavItems(icon: String) {
    let rightIcon = UIButton(type: .custom)
    rightIcon.setImage(UIImage (named: icon), for: .normal)
    rightIcon.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
    rightIcon.addTarget(self, action: #selector(changeTypeDisplay), for: .touchUpInside)
    let barButtonItem = UIBarButtonItem(customView: rightIcon)

    self.navigationItem.rightBarButtonItem = barButtonItem
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
      self.heightSearchBar.constant = 44
    } else {
      self.heightSearchBar.constant = 0
    }
  }
  @objc func changeTypeDisplay() {
    if isDisplayTable {
      setupRemainingNavItems(icon: "collection")
      isDisplayTable = false
      tableView.isHidden = false
      collectionView.isHidden = true
    } else {
      setupRemainingNavItems(icon: "table")
      isDisplayTable = true
      tableView.isHidden = true
      collectionView.isHidden = false
    }
  }

  func fetchSnippet() {
    do {
      let realm = try Realm()
      snippetList = realm.objects(Snippet.self)
    } catch {
      snippetList = nil
    }
  }

  func delete(index: Int) {
    guard let myFood = snippetList?[index] else { return }
    do {
      let realm = try Realm()
      try realm.write {
        realm.delete(myFood)
        self.tableView.reloadData()
      }
    } catch {
      print("can't delete")
    }
  }
}

extension HomeViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      tableView.reloadData()
    viewModel.getSnippets(keySearch: searchText) { [weak self] (result) in
      guard let this = self else { return }
      switch result {
      case .success:
        self!.tableView.reloadData()
      case .failure:
        this.alert(error: "Can't load data!")
      }
      this.viewDidUpdated()
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

    viewModel.getSnippets(keySearch: self.keySearch) { [weak self] (result) in
      guard let this = self else { return }
      switch result {
      case .success:
        self!.tableView.reloadData()
      case .failure:
        this.alert(error: "Can't load data!")
      }
      this.viewDidUpdated()
    }
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
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? HeaderCell
        else { fatalError() }
      return cell
    }

    guard let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeCell") as? YoutubeCell
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
    return 115
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    // 1
    let shareAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
      self.delete(index: indexPath.row)
      self.fetchSnippet()
      tableView.reloadData()
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
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionCell", for: indexPath) as? HeaderCollectionCell else {
        return UICollectionViewCell()
      }

      return cell
    }

    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell else {
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
      return UIEdgeInsets(top: 0.0,
                          left: 0.0,
                          bottom: 0,
                          right: 0.0)
    }
    return sectionInsets.self
  }
}
