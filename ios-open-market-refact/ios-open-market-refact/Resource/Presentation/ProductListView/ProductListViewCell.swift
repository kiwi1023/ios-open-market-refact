//
//  ProductListViewCell.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
//

import UIKit

final class ProductListViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupDefault()
//        addUIComponents()
//        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("ProductListViewController Initialize error")
    }
    
    //MARK: - Cell Default Setup
    private func setupDefault() {
//        NSLayoutConstraint.activate([
//
//        ])
    }
}
