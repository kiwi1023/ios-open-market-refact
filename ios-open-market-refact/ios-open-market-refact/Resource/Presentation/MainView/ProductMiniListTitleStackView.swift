//
//  ProductMiniListTitleStackView.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/11/16.
//

import UIKit

final class ProductMiniListTitleStackView: UIStackView {
    
    var moreButtonDelegate: MoreButtonTapDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1, compatibleWith: .none).bold()
        label.text = "🚨 이 상품 놓치지 마세요"
        return label
    }()
    
    private var moreListLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        label.setContentHuggingPriority(UILayoutPriority(100), for: .horizontal)
        label.text = "more ➡️"
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMoreButton))
        moreListLabel.addGestureRecognizer(tapGesture)
        moreListLabel.isUserInteractionEnabled = true
        addUIComponents()
        axis = .horizontal
        distribution = .fill
        alignment = .fill
    }
    
    private func addUIComponents() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(moreListLabel)
    }

    @objc private func tapMoreButton() {
        moreButtonDelegate?.moreButtonAddGesture()
    }
}
