//
//  HeaderCell.swift
//  MyApp
//
//  Created by MBA0103 on 8/30/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell, UIScrollViewDelegate {
  @IBOutlet weak var sliderScrollView: UIScrollView!
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var pageControl: UIPageControl!

  enum ImageSlider: String {
    case slide1
    case slide2
    case slide3
    case slide4
  }

  override func awakeFromNib() {
        super.awakeFromNib()
        setupScroll()
    }

  func setupScroll() {
    self.sliderScrollView.frame = CGRect(x: 0, y: 0, width: self.mainView.frame.width, height: self.mainView.frame.height)
    let scrollViewWidth: CGFloat = self.mainView.frame.width
    let scrollViewHeight: CGFloat = 210

    let imgOne = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgOne.image = UIImage(named: ImageSlider.slide1.rawValue)
    let imgTwo = UIImageView(frame: CGRect(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgTwo.image = UIImage(named: ImageSlider.slide2.rawValue)
    let imgThree = UIImageView(frame: CGRect(x: scrollViewWidth * 2, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgThree.image = UIImage(named: ImageSlider.slide3.rawValue)
    let imgFour = UIImageView(frame: CGRect(x: scrollViewWidth * 3, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgFour.image = UIImage(named: ImageSlider.slide4.rawValue)
    self.sliderScrollView.addSubview(imgOne)
    self.sliderScrollView.addSubview(imgTwo)
    self.sliderScrollView.addSubview(imgThree)
    self.sliderScrollView.addSubview(imgFour)
    //4
    self.sliderScrollView.contentSize = CGSize(width: self.sliderScrollView.frame.width * 4, height: self.sliderScrollView.frame.height)
    self.sliderScrollView.delegate = self
    self.pageControl.currentPage = 0
    self.mainView.bringSubview(toFront: pageControl)

    Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
  }

  @objc func moveToNextPage () {
    let pageWidth: CGFloat = self.sliderScrollView.frame.width
    let maxWidth: CGFloat = pageWidth * 4
    let contentOffset: CGFloat = self.sliderScrollView.contentOffset.x
    var slideToX = contentOffset + pageWidth
    if  contentOffset + pageWidth == maxWidth {
      slideToX = 0
    }
    self.sliderScrollView.scrollRectToVisible(CGRect(x: slideToX, y: 0, width: pageWidth, height: self.sliderScrollView.frame.height), animated: true)
  }
}

private typealias SliderScroll = HeaderCell
extension SliderScroll {
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    // Test the offset and calculate the current page after scrolling ends
    let pageWidth: CGFloat = scrollView.frame.width
    let currentPage: CGFloat = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
    // Change the indicator
    self.pageControl.currentPage = Int(currentPage)
    // Change the text accordingly
  }
}
