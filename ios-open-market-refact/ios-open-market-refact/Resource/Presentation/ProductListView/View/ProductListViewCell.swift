//
//  ProductListViewCell.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
//

import UIKit

final class ProductListViewCell: UICollectionViewCell {
    
    private(set) var product: Product?
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productStackView, seperatorLineView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, informationStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.directionalLayoutMargins = .init(top: .zero, leading: .zero, bottom: .zero, trailing: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, bargainPriceLabel])
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, quantityLabel, accessoryImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(data: UIImage(named: "testImage")?.compress() ?? Data())
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.setContentHuggingPriority(UILayoutPriority(100), for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.setContentHuggingPriority(UILayoutPriority(100), for: .horizontal)
        return label
    }()
    
    private let seperatorLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("ProductListViewController Initialize error")
    }
    
    //MARK: - Cell Default Setup
    private func setupDefault() {
        addUIComponents()
        setupLayout()
    }
    
    private func addUIComponents() {
        contentView.addSubview(mainStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .zero),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .zero),
        ])
        
        NSLayoutConstraint.activate([
            thumbnailImageView.heightAnchor.constraint(equalTo: productStackView.heightAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            accessoryImageView.topAnchor.constraint(equalTo: topStackView.topAnchor, constant: 8),
            accessoryImageView.bottomAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: -8),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 30),
            accessoryImageView.widthAnchor.constraint(equalTo: accessoryImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            seperatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configure(data: Product) {
        self.product = data
        guard let nsURL = NSURL(string: data.thumbnail) else {
            return
        }
        
        ImageCache.shared.load(url: nsURL) { image in
            self.thumbnailImageView.image = image
        }
        
        nameLabel.text = data.name
        
        priceLabel.text = data.price.priceFormat(currency: data.currency.rawValue)
        bargainPriceLabel.text = data.bargainPrice.priceFormat(currency: data.currency.rawValue)
        
        if data.price == data.bargainPrice {
            bargainPriceLabel.isHidden = true
            priceLabel.textColor = .systemGray3
        } else {
            bargainPriceLabel.isHidden = false
            priceLabel.textColor = .systemRed
            priceLabel.addStrikethrough()
        }
        
        quantityLabel.textColor = data.stock == .zero ? .systemOrange : .systemGray3
        quantityLabel.text = data.stock == .zero ? "품절" : "잔여수량: \(data.stock)"
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        guard let product = product,
              let nsURL = NSURL(string: product.thumbnail) else {
            return
        }
        ImageCache.shared.cancel(url: nsURL)
        thumbnailImageView.image = nil
    }
}
