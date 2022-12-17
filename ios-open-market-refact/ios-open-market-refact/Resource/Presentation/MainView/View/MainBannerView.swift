//
//  MainView.swift
//  realMainPage
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/17.
//

import UIKit

final class MainBannerView: SuperViewSetting {
    
    private let bannerViewModel = BannerViewModel()
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private var imageViews: [UIImageView] = []
    private var timer = Timer()
    
    //MARK: - Main Banner View Setup Methods
    
    override func setupDefault() {
        layer.cornerRadius = 20
        layer.masksToBounds = true
        bind()
        setupScrollView()
        startTimer()
    }
    
    override func addUIComponents() {
        addSubview(scrollView)
        addSubview(pageControl)
    }
    
    private func setupLayout(imageUrls count: Int) {
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
        
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(
            width: scrollView.frame.size.width * CGFloat(count + 2),
            height: bounds.height
        )
        scrollView.contentOffset.x = scrollView.frame.size.width
    }
    
    private func setImageViews(count: Int) {
        imageViews = []
        
        for index in 0..<count + 2 {
            let imageView = UIImageView(frame: bounds)
            
            imageView.contentMode = .scaleToFill
            imageView.frame.origin.x = bounds.width * CGFloat(index)
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    private func setupPageControl(imageUrls count: Int) {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.numberOfPages = count
        pageControl.allowsContinuousInteraction = false
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false
    }
    
    func bind() {
        let loadBannerImagesAction = Observable<Void>(())
        
        let output = bannerViewModel.transform(input: .init(loadBannerImagesAction: loadBannerImagesAction))
        
        output.loadBannerImagesOutPut.subscribe { [self] bannerImageUrls in
            DispatchQueue.main.async { [self] in
                getNumberOfImageUrls(count: bannerImageUrls.count - 2)
               
                guard imageViews.count != 2 else  { return }
                
                for (index , url) in bannerImageUrls.enumerated() {
                    configureBannerImages(index: index, url: url)
                }
            }
        }
    }
    
    private func getNumberOfImageUrls(count: Int) {
        setupLayout(imageUrls: count)
        setImageViews(count: count)
        setupPageControl(imageUrls: count)
    }
    
    private func configureBannerImages(index: Int, url: String) {
        guard let nsURL = NSURL(string: url) else { return  }
        
        ImageCache.shared.loadBannerImage(url: nsURL) { [self] image in
            imageViews[index].image = image
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
