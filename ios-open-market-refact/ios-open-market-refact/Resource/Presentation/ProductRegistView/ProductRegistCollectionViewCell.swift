//
//  ProductRegistCollectionViewCell.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductRegistCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "registCell"
    
    private(set) var registImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGroupedBackground
        button.isUserInteractionEnabled = false
        return button
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
        contentView.addSubview(registImageButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            registImageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            registImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            registImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            registImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(data: UIImage) {
        registImageButton.setImage(data, for: .normal)
    }
    
    func addTargetToImageButton(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        registImageButton.addTarget(target, action: action, for: controlEvents)
    }
}
