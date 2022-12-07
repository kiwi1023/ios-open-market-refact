//
//  ProductRegistView.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

private enum RegistrationBasicValueNameSpace {
    static let stringEmpty = ""
    static let stringZero = "0"
    static let doubleZero: Double = 0
    static let intZero: Int = 0
}

private enum ProductRegistViewNameSpace {
    static let productNamePlaceHolder = " 상품명"
    static let productPricePlaceHolder = " 판매 가격"
    static let productSalePlaceHolder = " 할인 금액"
    static let productStockPlaceHolder = " 재고 수량"
    static let productDescriptionPlaceHolder = " 텍스트를 입력하세요"
    static let productDefaultCurrency = "KRW"
}

final class ProductRegistView: SuperViewSetting {
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private(set) lazy var registCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionViewLayout()
        )
        
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var productInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameTextField,
                                                       productPriceTextField,
                                                       productSaleTextField,
                                                       productStockTextField,
                                                       productDescriptionTextView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ProductRegistViewNameSpace.productNamePlaceHolder
        textField.addLeftPadding()
        textField.layer.borderWidth = 0.1
        textField.layer.cornerRadius = 5
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
        return textField
    }()
    
    private let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ProductRegistViewNameSpace.productPricePlaceHolder
        textField.addLeftPadding()
        textField.layer.borderWidth = 0.1
        textField.layer.cornerRadius = 5
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
        return textField
    }()
    
    private let productSaleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ProductRegistViewNameSpace.productSalePlaceHolder
        textField.addLeftPadding()
        textField.layer.borderWidth = 0.1
        textField.layer.cornerRadius = 5
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
        return textField
    }()
    
    private let productStockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ProductRegistViewNameSpace.productStockPlaceHolder
        textField.addLeftPadding()
        textField.layer.borderWidth = 0.1
        textField.layer.cornerRadius = 5
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
        return textField
    }()
    
    private lazy var productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 0.1
        textView.layer.cornerRadius = 5
        textView.font = .preferredFont(forTextStyle: .title3)
        textView.setContentHuggingPriority(UILayoutPriority(50), for: .vertical)
        return textView
    }()
    
    // MARK: - Setup Functions
    
    override func setupDefault() {
        setupTextViewPlaceHolder()
        
        productNameTextField.delegate = self
        productSaleTextField.delegate = self
        productStockTextField.delegate = self
        productPriceTextField.delegate = self
        productDescriptionTextView.delegate = self
    }
    
    override func addUIComponents() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(registCollectionView)
        mainStackView.addArrangedSubview(productInfoStackView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            mainScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            mainStackView.heightAnchor.constraint(greaterThanOrEqualTo: mainScrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            registCollectionView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            registCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.21)
        ])
    }
    
    // MARK: - Setup Collection View Method
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalWidth(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setupTextViewPlaceHolder() {
        let text = productDescriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text == "" {
            productDescriptionTextView.text = ProductRegistViewNameSpace.productDescriptionPlaceHolder
            productDescriptionTextView.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        }
    }
    
    func makeProduct() -> RegistrationProduct {
        return RegistrationProduct(name: productNameTextField.text ?? RegistrationBasicValueNameSpace.stringEmpty,
                                   description: productDescriptionTextView.text ?? RegistrationBasicValueNameSpace.stringEmpty,
                                   price: Double(productPriceTextField.text ?? RegistrationBasicValueNameSpace.stringZero) ?? RegistrationBasicValueNameSpace.doubleZero,
                                   currency: ProductRegistViewNameSpace.productDefaultCurrency,
                                   discountedPrice: Double(productSaleTextField.text ?? RegistrationBasicValueNameSpace.stringZero) ?? RegistrationBasicValueNameSpace.doubleZero,
                                   stock: Int(productStockTextField.text ?? RegistrationBasicValueNameSpace.stringZero) ?? RegistrationBasicValueNameSpace.intZero,
                                   secret: UserInfo.secret)
    }
    
    func configureProduct(product: ProductDetail) {
        productNameTextField.text = product.name
        productPriceTextField.text = "\(Int(product.price))"
        productSaleTextField.text = "\(Int(product.discountedPrice))"
        productStockTextField.text = "\(product.stock)"
        productDescriptionTextView.text = product.description
        if !productDescriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            productDescriptionTextView.textColor = .black
        }
    }
}

// MARK: - UITextFieldDelegate Functions

extension ProductRegistView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 15
    }
}

// MARK: - UITextViewDelegate Functions

extension ProductRegistView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == ProductRegistViewNameSpace.productDescriptionPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = ProductRegistViewNameSpace.productDescriptionPlaceHolder
            textView.textColor = .lightGray.withAlphaComponent(0.7)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text,
              let newRange = Range(range, in: oldString) else { return true }
        
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        guard characterCount <= 700 else { return false }
        
        return true
    }
}
