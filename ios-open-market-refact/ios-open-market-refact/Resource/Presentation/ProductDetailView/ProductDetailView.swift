//
//  ProductDetailView.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductDetailView: SuperViewSetting, UIScrollViewDelegate {
    
    private let productScrollview = UIScrollView()
    private var currentPage = 0 {
        didSet {
            changeCurrentPage?()
        }
    }
    
    private let photoIndexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
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
        addSubview(productScrollview)
        addSubview(photoIndexLabel)
        addSubview(venderStackView)
        venderStackView.addArrangedSubview(venderImageView)
        venderStackView.addArrangedSubview(venderNameLabel)
        addSubview(spacingView)
        addSubview(descriptionLabel)
    }
    
    override func setupLayout() {
        let topMargin = CGFloat(10)
        let leadingMargin = CGFloat(20)
        let trailingMargin = CGFloat(-20)
        
        NSLayoutConstraint.activate([
            productScrollview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: topMargin),
            productScrollview.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            productScrollview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            productScrollview.heightAnchor.constraint(equalTo: productScrollview.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photoIndexLabel.topAnchor.constraint(equalTo: productScrollview.bottomAnchor),
            photoIndexLabel.centerXAnchor.constraint(equalTo: productScrollview.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            venderStackView.topAnchor.constraint(equalTo: photoIndexLabel.bottomAnchor, constant: topMargin),
            venderStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: leadingMargin),
            venderStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: trailingMargin)
        ])
        
        NSLayoutConstraint.activate([
        venderImageView.heightAnchor.constraint(equalTo: venderImageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            spacingView.topAnchor.constraint(equalTo: venderStackView.bottomAnchor, constant: topMargin),
            spacingView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: leadingMargin),
            spacingView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: trailingMargin),
            spacingView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: spacingView.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: leadingMargin),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: trailingMargin)
        ])
        
      
    }
    
    private func setupProductScrollview() {
        productScrollview.translatesAutoresizingMaskIntoConstraints = false
        productScrollview.delegate = self // scroll범위에 따라 pageControl의 값을 바꾸어주기 위한 delegate
        productScrollview.alwaysBounceVertical = false
        productScrollview.showsHorizontalScrollIndicator = false
        productScrollview.showsVerticalScrollIndicator = false
        productScrollview.isScrollEnabled = true
        productScrollview.isPagingEnabled = true
        productScrollview.bounces = false // 경계지점에서
        productScrollview.clipsToBounds = true
        productScrollview.layer.cornerRadius = 15
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
            productScrollview.contentSize = CGSize(width: productScrollview.bounds.width * CGFloat(productDetail.images.count), height: productScrollview.bounds.height)
        }
        
        for (index, image) in productDetail.images.enumerated() {
            guard let url = URL(string: image.url),
                  let data = try? Data(contentsOf: url),
                  let seletedImage = UIImage(data: data) else { return }
            let imageView = UIImageView(image: seletedImage)
            
            DispatchQueue.main.async { [self] in
                imageView.frame = productScrollview.bounds
                imageView.frame.origin.x = productScrollview.bounds.width * CGFloat(index)
                imageView.contentMode = .scaleToFill
            }
            
            productScrollview.addSubview(imageView)
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
            self.currentPage = Int(round(scrollView.contentOffset.x / productScrollview.bounds.width)) + 1
        }
    }
}
