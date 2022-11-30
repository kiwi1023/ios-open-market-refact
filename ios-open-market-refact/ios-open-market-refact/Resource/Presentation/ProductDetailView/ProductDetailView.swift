//
//  ProductDetailView.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductDetailView: SuperViewSetting, UIScrollViewDelegate {
    
    private let mainScrollView = UIScrollView()
    private let productScrollView = UIScrollView()
    private var currentPage = 1 {
        didSet {
            changeCurrentPage?()
        }
    }
    
    private let photoIndexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var venderStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [venderImageView, venderNameLabel]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    private let venderImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let venderNameLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none)
        return label
    }()
    
    private let spacingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.baselineAdjustment = .none
        label.alpha = 0.6
        label.numberOfLines = 0
        label.setContentHuggingPriority(UILayoutPriority(100), for: .vertical)
        return label
    }()
    
    private let productInfoStackView = ProductInfoStackView()
    
    //MARK: - Setup View Method
    
    override func setupDefault() {
        setupProductScrollview()
    }
    
    override func addUIComponents() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(productScrollView)
        mainScrollView.addSubview(photoIndexLabel)
        mainScrollView.addSubview(venderStackView)
        venderStackView.addArrangedSubview(venderImageView)
        venderStackView.addArrangedSubview(venderNameLabel)
        mainScrollView.addSubview(spacingView)
        mainScrollView.addSubview(descriptionLabel)
    }
    
    override func setupLayout() {
        let topMargin = CGFloat(10)
        let leadingMargin = CGFloat(20)
        let trailingMargin = CGFloat(-20)
        
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.contentSize.width = self.bounds.width
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            productScrollView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor, constant: topMargin),
            productScrollView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            productScrollView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 40),
            productScrollView.heightAnchor.constraint(equalTo: productScrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photoIndexLabel.topAnchor.constraint(equalTo: productScrollView.bottomAnchor),
            photoIndexLabel.leadingAnchor.constraint(equalTo: productScrollView.leadingAnchor),
            photoIndexLabel.trailingAnchor.constraint(equalTo: productScrollView.trailingAnchor),
            photoIndexLabel.centerXAnchor.constraint(equalTo: productScrollView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            venderStackView.topAnchor.constraint(equalTo: photoIndexLabel.bottomAnchor, constant: topMargin),
            venderStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: leadingMargin),
            venderStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: trailingMargin)
        ])
        
        NSLayoutConstraint.activate([
            venderImageView.heightAnchor.constraint(equalTo: venderImageView.widthAnchor),
            venderImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            spacingView.topAnchor.constraint(equalTo: venderStackView.bottomAnchor, constant: topMargin),
            spacingView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: leadingMargin),
            spacingView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: trailingMargin),
            spacingView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: spacingView.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: leadingMargin),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: trailingMargin),
            descriptionLabel.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupProductScrollview() {
        productScrollView.translatesAutoresizingMaskIntoConstraints = false
        productScrollView.delegate = self // scroll범위에 따라 pageControl의 값을 바꾸어주기 위한 delegate
        productScrollView.alwaysBounceVertical = false
        productScrollView.showsHorizontalScrollIndicator = false
        productScrollView.showsVerticalScrollIndicator = false
        productScrollView.isScrollEnabled = true
        productScrollView.isPagingEnabled = true
        productScrollView.bounces = false // 경계지점에서
        productScrollView.clipsToBounds = true
        productScrollView.layer.cornerRadius = 15
    }
    
    private func setUpProductInfoStackViewLayout(productDetail: ProductDetail) {
        productInfoStackView.setupProductDetail(productDetail: productDetail)
        
        addSubview(productInfoStackView)
        
        NSLayoutConstraint.activate([
            productInfoStackView.heightAnchor.constraint(equalToConstant: 50),
            productInfoStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            productInfoStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            productInfoStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureImageView(_ productDetail: ProductDetail) {
        DispatchQueue.main.async { [self] in
            productScrollView.contentSize = CGSize(width: productScrollView.bounds.width * CGFloat(productDetail.images.count), height: productScrollView.bounds.height)
        }
        
        for (index, image) in productDetail.images.enumerated() {
            let imageView = UIImageView()
            guard let url = NSURL(string: image.url) else { return }
            ImageCache.shared.load(url: url) { image in
                imageView.image = image
            }
            
            DispatchQueue.main.async { [self] in
                imageView.frame = productScrollView.bounds
                imageView.frame.origin.x = productScrollView.bounds.width * CGFloat(index)
                imageView.contentMode = .scaleToFill
            }
            
            productScrollView.addSubview(imageView)
        }
    }
    
    func getProductDetailData(productDetail: ProductDetail) {
        configureImageView(productDetail)
        photoIndexLabel.text = "\(currentPage) / \(productDetail.images.count)"
        venderImageView.image = UIImage(systemName: "person.circle")
        venderNameLabel.text = productDetail.vendors.name
        descriptionLabel.text = productDetail.description
        setUpProductInfoStackViewLayout(productDetail: productDetail)
    }
    
    var changeCurrentPage: (() -> Void)?
}

extension ProductDetailView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async { [self] in
            self.currentPage = Int(round(scrollView.contentOffset.x / productScrollView.bounds.width)) + 1
        }
    }
}
