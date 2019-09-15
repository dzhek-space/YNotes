//
//  ViewController.swift
//  YNotes
//
//  Created by Dzhek on 07/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Class

class GalleryViewController: UIViewController, UIScrollViewDelegate {

    //MARK: • IBOutlets
    
    @IBOutlet weak var galleryScrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    //MARK: - • Properties
    
    var slides: [SlideView] = []
    
    //MARK: - • LiveCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slides = createSlides()
        self.setupGalleryScrollView(slides: slides)
        
        self.pageControll.numberOfPages = slides.count
        self.pageControll.currentPage = 0
        self.pageControll.pageIndicatorTintColor = .groupTableViewBackground
        self.pageControll.currentPageIndicatorTintColor = UIColor(hex: "01B3E4")
        self.view.bringSubviewToFront(self.pageControll)
        
        self.galleryScrollView.delegate = self
    }
    
    //MARK: - • Methods
    
    func createSlides() -> [SlideView] {
        
        var slidesArray = [SlideView]()
        
        for i in 1...6 {
            let slide: SlideView = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! SlideView
            let imageName: String = "st_" + String(i)
            slide.pictureView.image = UIImage(named: imageName)
            slidesArray.append(slide)
        }
        
        return slidesArray
    }
    
    func setupGalleryScrollView(slides: [SlideView]) {
        self.galleryScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.galleryScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(slides.count),
                                                    height: self.view.frame.height)
        self.galleryScrollView.isPagingEnabled = true
        
        for i in 0..<slides.count {
            slides[i].frame = CGRect(x: self.view.frame.width * CGFloat(i),
                                     y: 0,
                                     width: self.view.frame.width,
                                     height: self.view.frame.height)
            galleryScrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/self.view.frame.width)
        self.pageControll.currentPage = Int(pageIndex)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.setupGalleryScrollView(slides: slides)
    }
    
}
