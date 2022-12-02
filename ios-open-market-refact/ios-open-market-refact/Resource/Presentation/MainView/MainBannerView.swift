//
//  MainView.swift
//  realMainPage
//
//  Created by Kiwon Song on 2022/11/17.
//

import UIKit

final class MainBannerView: UIView {
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var imageViews: [UIImageView] = []
    var imageUrls: [String] = [] {
        didSet {
            configureLayout()
            setupPageControl()
            setupScrollView()
            startTimer()
        }
    }
    var timer = Timer()
    
    
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        debugPrint("ProductListViewController Initialize error")
    }
    
    private func setupPageControl() {
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
    
    private func configureLayout() {
        self.addSubview(scrollView)
        self.addSubview(pageControl)

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
        
        DispatchQueue.main.async { [self] in
            scrollView.frame = self.bounds
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(imageUrls.count + 2), height: self.bounds.height)
            scrollView.contentOffset.x = scrollView.frame.size.width
        }
        
        DispatchQueue.main.async { [self] in
            for index in 0..<imageUrls.count + 2 {
                let imageView = UIImageView(frame: self.bounds)
                imageView.contentMode = .scaleToFill
                imageView.frame.origin.x = self.bounds.width * CGFloat(index)
                
                scrollView.addSubview(imageView)
                imageViews.append(imageView)
            }
            downloadImages()
        }
    }
  
    
     func downloadImages() {
        for i in 0..<imageViews.count {
            var urlStr = ""
            if i == 0 {
                urlStr = imageUrls.last ?? ""
            } else if i == imageViews.count - 1 {
                urlStr = imageUrls.first ?? ""
            } else {
                urlStr = imageUrls[i - 1]
            }
            
            guard let nsURL = NSURL(string: urlStr) else {
                return
            }
            
            ImageCache.shared.loadBannerImage(url: nsURL) { [self] image in
                self.imageViews[i].image = image
            }
        }
    }
    
    func infiniteScroll() {
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x = self.scrollView.bounds.width * CGFloat((imageViews.count - 2))
        } else if scrollView.contentOffset.x == (self.scrollView.bounds.width * CGFloat((imageViews.count - 1))) {
            scrollView.contentOffset.x = self.scrollView.bounds.width * CGFloat(1)
        }
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width) - 1
        
        pageControl.currentPage = index
    }
    
    func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { timer in
            
            let index = Int(self.scrollView.contentOffset.x / self.scrollView.bounds.width)
            var nextIndex = index + 1
            
            if nextIndex == self.imageViews.count {
                nextIndex = 0
            }
            
            let newOffset = CGFloat(nextIndex) * CGFloat(self.scrollView.bounds.width)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset.x = newOffset
            }) { (_) in
                self.infiniteScroll()
            }
        })
    }
    
    func stopTimer() {
        self.timer.invalidate()
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
