//
//  ProductDetailView.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductDetailView: SuperViewSetting {
    
    private let mainImageView: DownloadableUIImageView = {
        let imageView = DownloadableUIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority(750), for: .vertical)
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none).bold()
        return label
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
    
   
    
    //MARK: - Setup View Method
    
    override func addUIComponents() {
        addSubview(mainImageView)
        addSubview(venderStackView)
        venderStackView.addArrangedSubview(venderImageView)
        venderStackView.addArrangedSubview(venderNameLabel)
        addSubview(spacingView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
    }
    
    override func setupLayout() {
        let topMargin = CGFloat(20)
        let leadingMargin = CGFloat(20)
        let trailingMargin = CGFloat(-20)
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: topMargin),
            mainImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            mainImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            venderStackView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: topMargin),
            venderStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: leadingMargin),
            venderStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: trailingMargin)
        ])
        
        venderImageView.widthAnchor.constraint(equalTo: venderStackView.widthAnchor, multiplier: 0.1).isActive = true
        venderImageView.heightAnchor.constraint(equalTo: venderImageView.widthAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            spacingView.topAnchor.constraint(equalTo: venderStackView.bottomAnchor, constant: topMargin),
            spacingView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: leadingMargin),
            spacingView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: trailingMargin),
            spacingView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: spacingView.bottomAnchor, constant: topMargin),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: leadingMargin),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: trailingMargin)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: leadingMargin),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: trailingMargin)
        ])
        
      
    }
    
    private func getProductInfoStackViewData(productDetail: ProductDetail) {
        let productInfoStackView = ProductInfoStackView(productDetail: productDetail)
        
        addSubview(productInfoStackView)
        
        NSLayoutConstraint.activate([
            productInfoStackView.heightAnchor.constraint(equalToConstant: 50),
            productInfoStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(20)),
            productInfoStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: CGFloat(-20)),
            productInfoStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    func getProductDetailData(productDetail: ProductDetail) {
       
        mainImageView.setImageUrl(productDetail.thumbnail)
        venderImageView.image = UIImage(systemName: "person.circle")
        venderNameLabel.text = productDetail.vendors.name
        titleLabel.text = productDetail.name
        descriptionLabel.text = productDetail.description
        getProductInfoStackViewData(productDetail: productDetail)
    }
}
