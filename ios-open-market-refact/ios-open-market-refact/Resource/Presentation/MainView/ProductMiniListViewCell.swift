//
//  ProductListViewCell.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
//

import UIKit

final class ProductMiniListViewCell: UICollectionViewCell {
    
    private var product: Product?
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(data: UIImage().compress() ?? Data())
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3).bold()
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
    }
    
    //MARK: - Cell Default Setup
    private func setupDefault() {
        addUIComponents()
        setupLayout()
    }
    
    private func addUIComponents() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(nameLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func configure(data: Product) {
        guard let nsURL = NSURL(string: data.thumbnail) else { return }
        
        ImageCache.shared.load(url: nsURL) {  image in
            self.thumbnailImageView.image = image
        }
        
        nameLabel.text = data.name
        product = data
    }
    
    override func prepareForReuse() {
        guard let product = product,
              let nsURL = NSURL(string: product.thumbnail) else { return }
        
        ImageCache.shared.cancel(url: nsURL)
        thumbnailImageView.image = nil
    }
}
