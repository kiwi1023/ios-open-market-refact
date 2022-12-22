//
//  ProductMiniListTitleStackView.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/16.
//

import UIKit

protocol MoreButtonTapDelegate: AnyObject {
    
    func moreButtonAddGesture()
}

final class ProductMiniListTitleStackView: UIStackView {
    
    //MARK: ProductMiniListTitleStackView NameSpace
    
    private enum ProductMiniListTitleStackViewNameSpace {
        static let titleLabelContent = "🚨 이 상품 놓치지 마세요"
        static let moreListLabelContent = "more ➡️"
    }
    
    weak var moreButtonDelegate: MoreButtonTapDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1, compatibleWith: .none).bold()
        label.text = ProductMiniListTitleStackViewNameSpace.titleLabelContent
        return label
    }()
    
    private let moreListLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        label.setContentHuggingPriority(UILayoutPriority(100), for: .horizontal)
        label.text = ProductMiniListTitleStackViewNameSpace.moreListLabelContent
        label.textAlignment = .right
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupDefaults()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Setup ProductMiniListTitleStackView
    
    private func setupDefaults() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fill
        alignment = .fill
        
        setupTapGesture()
        addUIComponents()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(tapMoreButton)
        )
        
        moreListLabel.addGestureRecognizer(tapGesture)
        moreListLabel.isUserInteractionEnabled = true
    }
    
    private func addUIComponents() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(moreListLabel)
    }
    
    @objc private func tapMoreButton() {
        moreButtonDelegate?.moreButtonAddGesture()
    }
}
