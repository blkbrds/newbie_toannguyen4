//
//  HeaderCell.swift
//  MyApp
//
//  Created by MBA0103 on 8/30/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class HeaderCell: UITableViewCell, UIScrollViewDelegate {
  @IBOutlet weak private var sliderScrollView: UIScrollView!
  @IBOutlet weak private var mainView: UIView!
  @IBOutlet weak private var pageControl: UIPageControl!

  enum ImageSlider: String {
    case slide1 = "img-slide1"
    case slide2 = "img-slide2"
    case slide3 = "img-slide3"
    case slide4 = "img-slide4"
  }

  override func awakeFromNib() {
        super.awakeFromNib()
        setupScroll()
    }

  func setupScroll() {
    sliderScrollView.frame = CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height)
    let scrollViewWidth: CGFloat = UIScreen.main.bounds.width
    let scrollViewHeight: CGFloat = 210

    let imgOne = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgOne.image = UIImage(named: ImageSlider.slide1.rawValue)
    let imgTwo = UIImageView(frame: CGRect(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgTwo.image = UIImage(named: ImageSlider.slide2.rawValue)
    let imgThree = UIImageView(frame: CGRect(x: scrollViewWidth * 2, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgThree.image = UIImage(named: ImageSlider.slide3.rawValue)
    let imgFour = UIImageView(frame: CGRect(x: scrollViewWidth * 3, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    imgFour.image = UIImage(named: ImageSlider.slide4.rawValue)
    sliderScrollView.addSubview(imgOne)
    sliderScrollView.addSubview(imgTwo)
    sliderScrollView.addSubview(imgThree)
    sliderScrollView.addSubview(imgFour)
    //4
    sliderScrollView.contentSize = CGSize(width: sliderScrollView.frame.width * 4, height: sliderScrollView.frame.height)
    sliderScrollView.delegate = self
    pageControl.currentPage = 0
    mainView.bringSubview(toFront: pageControl)

    Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
  }

  @objc func moveToNextPage () {
    let pageWidth: CGFloat = sliderScrollView.frame.width
    let maxWidth: CGFloat = pageWidth * 4
    let contentOffset: CGFloat = sliderScrollView.contentOffset.x
    var slideToX = contentOffset + pageWidth
    if  contentOffset + pageWidth == maxWidth {
      slideToX = 0
    }
    sliderScrollView.scrollRectToVisible(CGRect(x: slideToX, y: 0, width: pageWidth, height: sliderScrollView.frame.height), animated: true)
  }
}

private typealias SliderScroll = HeaderCell

extension SliderScroll {
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    // Test the offset and calculate the current page after scrolling ends
    let pageWidth: CGFloat = scrollView.frame.width
    let currentPage: CGFloat = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
    // Change the indicator
    pageControl.currentPage = Int(currentPage)
    // Change the text accordingly
  }
}
