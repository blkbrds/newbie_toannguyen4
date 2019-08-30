//
//  HomeViewController.swift
//  MyApp
//
//  Created by MBA0103 on 8/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import  MVVM

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

  private var isDisplayTable = true

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
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    viewModel.getSnippets { [weak self] (result) in
      guard let this = self else { return }
      switch result {
      case .success:
        self!.tableView.reloadData()
        break
      case .failure:
        print("loi")
        //this.alert(error: "loi" as! Error)
      }
      this.viewDidUpdated()
    }
  }

  func updateView() {
    guard isViewLoaded else { return }
    tableView.reloadData()
    viewDidUpdated()
  }

  private func setupTableView() {
    tableView.register(UINib(nibName: "YoutubeCell", bundle: nil), forCellReuseIdentifier: "YoutubeCell")
    tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    tableView.dataSource = self
    tableView.delegate = self
    tableView.reloadData()
  }

  func setupCollectionView() {
    let cellNib = UINib(nibName: "HomeCollectionCell", bundle: Bundle.main)
    collectionView.register(cellNib, forCellWithReuseIdentifier: "HomeCollectionCell")
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

  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == SectionTableView.kHeaderSection.rawValue {
      return 210
    }
    return 115
  }
}

extension HomeViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItems(inSection: section)
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell else {
      return UICollectionViewCell()
    }
    cell.viewModel = viewModel.viewModelForItem(at: indexPath)
    kCellheight = cell.imageThumbnail.frame.height + cell.imageThumbnail.frame.height
    return cell
  }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (kCellWidth - kMarginLeft - kMarginRight), height: kCellWidth - 30)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets.self
  }
}
