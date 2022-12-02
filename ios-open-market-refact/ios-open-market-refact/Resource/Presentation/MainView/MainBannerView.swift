//
//  MainView.swift
//  realMainPage
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/17.
//

import UIKit

final class MainBannerView: SuperViewSetting {
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private var imageViews: [UIImageView] = []
    var imageUrls: [String] = [] {
        didSet {
            configureScrollView()
            setupPageControl()
            setupScrollView()
            startTimer()
        }
    }
    private var timer = Timer()
    
    //MARK: - Main Banner View Setup Methods
    
    override func setupDefault() {
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    override func addUIComponents() {
        addSubview(scrollView)
        addSubview(pageControl)
    }
    
    private func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.numberOfPages = imageUrls.count
        pageControl.allowsContinuousInteraction = false
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false
    }
    
    private func configureScrollView() {
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
        
        DispatchQueue.main.async { [self] in
            scrollView.frame = bounds
            scrollView.contentSize = CGSize(
                width: scrollView.frame.size.width * CGFloat(imageUrls.count + 2),
                height: bounds.height
            )
            scrollView.contentOffset.x = scrollView.frame.size.width
        }
        
        DispatchQueue.main.async { [self] in
            for index in 0..<imageUrls.count + 2 {
                let imageView = UIImageView(frame: bounds)
                
                imageView.contentMode = .scaleToFill
                imageView.frame.origin.x = bounds.width * CGFloat(index)
                scrollView.addSubview(imageView)
                imageViews.append(imageView)
            }
            downloadImages()
        }
    }
    
    private func downloadImages() {
        for i in 0..<imageViews.count {
            var urlStr = ""
            
            if i == 0 {
                urlStr = imageUrls.last ?? ""
            } else if i == imageViews.count - 1 {
                urlStr = imageUrls.first ?? ""
            } else {
                urlStr = imageUrls[i - 1]
            }
            
            guard let nsURL = NSURL(string: urlStr) else { return  }
            
            ImageCache.shared.loadBannerImage(url: nsURL) { [self] image in
                imageViews[i].image = image
            }
        }
    }
    
    private func infiniteScroll() {
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x = scrollView.bounds.width * CGFloat((imageViews.count - 2))
        } else if scrollView.contentOffset.x == (scrollView.bounds.width * CGFloat((imageViews.count - 1))) {
            scrollView.contentOffset.x = scrollView.bounds.width * CGFloat(1)
        }
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width) - 1
        
        pageControl.currentPage = index
    }
    
    private func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { [self] timer in
            
            let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            var nextIndex = index + 1
            
            if nextIndex == imageViews.count {
                nextIndex = 0
            }
            
            let newOffset = CGFloat(nextIndex) * CGFloat(scrollView.bounds.width)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset.x = newOffset
            }) { _ in
                self.infiniteScroll()
            }
        })
    }
    
    private func stopTimer() {
        timer.invalidate()
    }
}

extension MainBannerView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        infiniteScroll()
        startTimer()
    }
}
