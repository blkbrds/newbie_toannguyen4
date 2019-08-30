//
//  HeaderCollectionCell.swift
//  MyApp
//
//  Created by MBA0103 on 8/30/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class HeaderCollectionCell: UICollectionViewCell, UIScrollViewDelegate {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var viewScroll: UIView!
  override func awakeFromNib() {
    super.awakeFromNib()
    setupScroll()
  }

  func setupScroll() {
    self.scrollView.frame = CGRect(x: 0, y: 0, width: self.viewScroll.frame.width, height: self.viewScroll.frame.height)
    let scrollViewWidth: CGFloat = self.viewScroll.frame.width
    let scrollViewHeight: CGFloat = 210//self.viewScroll.frame.height
    print(self.scrollView.frame.height)
    print(self.viewScroll.frame.height)

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

private typealias ScrollView = HeaderCollectionCell
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
