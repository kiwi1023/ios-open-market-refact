//
//  ProductRegistCollectionViewCell.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductRegistCollectionViewCell: UICollectionViewCell {
    
    private let registImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGroupedBackground
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let deleteImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    var removeImage: (() -> Void)?
    
    // MARK: - Cell Initializer
    
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
        contentView.addSubview(registImageButton)
        contentView.addSubview(deleteImageButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            registImageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            registImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            registImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            registImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteImageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteImageButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            deleteImageButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2)
        ])
    }
    
    override func prepareForReuse() {
        registImageButton.imageView?.image = nil
        deleteImageButton.isHidden = false
    }
    
    @objc private func didTapRemoveButton() {
        removeImage?()
    }
    
    func configureImage(data: UIImage) {
        registImageButton.setImage(data, for: .normal)
        deleteImageButton.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
    }
    
    func hideDeleteImageButton() {
        deleteImageButton.isHidden = true
    }
}
