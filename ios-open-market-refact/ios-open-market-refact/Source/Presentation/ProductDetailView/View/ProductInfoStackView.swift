//
//  ProductInfoStackView.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductInfoStackView: UIStackView {
    
    private var productDetail: ProductDetail?
    private var isStarToggled = true
    
    //MARK: - Product Info StackView UIComponents frame
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star"))
        imageView.layer.masksToBounds = false
        imageView.layer.shadowRadius = 2
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .yellow
        return imageView
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [originalPriceLabel, bargainPriceLabel])
        stackView.setContentHuggingPriority(UILayoutPriority(100), for: .horizontal)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .none)
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none)
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupDefault()
        addStackViewComponents()
        setupProductDetailViewData()
        setupPriceLabelAttribute()
    }
    
    required init(coder: NSCoder) {
        productDetail = nil
        super.init(coder: coder)
    }
    
    //MARK: - Setup StackView Default
    
    private func setupDefault() {
        axis = .horizontal
        distribution = .fillProportionally
        alignment = .fill
        spacing = 10
        
        setupStarImageViewTapGesture()
        starToggle()
    }
    
    private func setupStarImageViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starToggle))
        starImageView.addGestureRecognizer(tapGesture)
        starImageView.isUserInteractionEnabled = true
    }
    
    private func addStackViewComponents() {
        addArrangedSubview(starImageView)
        addArrangedSubview(priceStackView)
        priceStackView.addArrangedSubview(originalPriceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
        addArrangedSubview(stockLabel)
    }
    
    func setupProductDetail(productDetail: ProductDetail) {
        self.productDetail = productDetail
        setupProductDetailViewData()
        setupPriceLabelAttribute()
    }
    
    private func setupProductDetailViewData() {
        let stockString = productDetail?.stock.numberFormattingToDecimal()
        
        stockLabel.text = "\(stockString ?? "0")개 남음"
    }
    
    private func setupPriceLabelAttribute() {
        guard let productDetail = productDetail else { return }
        
        var originalPriceString = productDetail.price.numberFormattingToDecimal()
        var bargainPriceString = productDetail.bargainPrice.numberFormattingToDecimal()
        
        originalPriceString = "\(originalPriceString)원"
        bargainPriceString = "\(bargainPriceString)원"
        
        if productDetail.discountedPrice == 0 {
            bargainPriceLabel.isHidden = true
            let originalAttributedString = NSMutableAttributedString(string: originalPriceString)
            originalAttributedString.setAttributes(
                [.foregroundColor: UIColor.black],
                range: NSMakeRange(0, originalPriceString.count)
            )
            originalPriceLabel.attributedText = originalAttributedString
            
        } else {
            let originalAttributedString = NSMutableAttributedString(string: originalPriceString)
            let bargainAttributedString = NSMutableAttributedString(string: bargainPriceString)
            
            originalAttributedString.setAttributes(
                [.foregroundColor: UIColor.lightGray,
                 .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ],
                range: NSMakeRange(0, originalPriceString.count)
            )
            
            bargainAttributedString.setAttributes(
                [.foregroundColor: UIColor.red],
                range: NSMakeRange(0, bargainPriceString.count)
            )
            
            originalPriceLabel.attributedText = originalAttributedString
            bargainPriceLabel.attributedText = bargainAttributedString
        }
    }
    
    //MARK: - Star ImageView Touch Event
    
    @objc private func starToggle() {
        if isStarToggled {
            starImageView.image = UIImage(systemName: "star")?.withTintColor(.yellow)
        } else {
            starImageView.image = UIImage(systemName: "star.fill")?.withTintColor(.yellow)
        }
        isStarToggled = !isStarToggled
    }
}
