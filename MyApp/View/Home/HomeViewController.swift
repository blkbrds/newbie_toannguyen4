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
  @IBOutlet weak var viewScroll: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var pageControl: UIPageControl!
  private var isDisplayTable = true
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRemainingNavItems(icon: "table")
    setupScroll()
    setupTableView()
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
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    tableView.dataSource = self
    tableView.delegate = self
    tableView.reloadData()
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
    } else {
      setupRemainingNavItems(icon: "table")
      isDisplayTable = true
      tableView.isHidden = true
    }
  }

  func setupScroll() {
    self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.viewScroll.frame.height)
    let scrollViewWidth: CGFloat = self.scrollView.frame.width
    let scrollViewHeight: CGFloat = self.scrollView.frame.height

    let imgOne = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgOne.image = UIImage(named: "slide1")
    let imgTwo = UIImageView(frame: CGRect(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgTwo.image = UIImage(named: "slide2")
    let imgThree = UIImageView(frame: CGRect(x: scrollViewWidth * 2, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgThree.image = UIImage(named: "slide3")
    let imgFour = UIImageView(frame: CGRect(x: scrollViewWidth * 3, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgFour.image = UIImage(named: "slide4")
    self.scrollView.addSubview(imgOne)
    self.scrollView.addSubview(imgTwo)
    self.scrollView.addSubview(imgThree)
    self.scrollView.addSubview(imgFour)
    //4
    self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 4, height: self.scrollView.frame.height)
    self.scrollView.delegate = self
    self.pageControl.currentPage = 0
    self.viewScroll.bringSubview(toFront: pageControl)

    Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
  }

  @objc func moveToNextPage () {
    let pageWidth: CGFloat = self.scrollView.frame.width
    let maxWidth: CGFloat = pageWidth * 4
    let contentOffset: CGFloat = self.scrollView.contentOffset.x
    var slideToX = contentOffset + pageWidth
    if  contentOffset + pageWidth == maxWidth {
      slideToX = 0
    }
    self.scrollView.scrollRectToVisible(CGRect(x: slideToX, y: 0, width: pageWidth, height: self.scrollView.frame.height), animated: true)
  }
}

private typealias ScrollView = HomeViewController
extension ScrollView {
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    // Test the offset and calculate the current page after scrolling ends
    let pageWidth: CGFloat = scrollView.frame.width
    let currentPage: CGFloat = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
    // Change the indicator
    self.pageControl.currentPage = Int(currentPage)
    // Change the text accordingly
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
    return 115
  }
}
