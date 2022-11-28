//
//  ProductRegistView.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductRegistView: UIView {
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductRegistCollectionViewCell.self, forCellWithReuseIdentifier: ProductRegistCollectionViewCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var productInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameTextField,
                                                       productPriceTextField,
                                                       productSaleTextField,
                                                       productStockTextField,
                                                       productDescriptionTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " 상품명"
        textField.addLeftPadding()
        textField.layer.borderWidth = 0.1
        textField.layer.cornerRadius = 5
        textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
        return textField
    }()
    
    private let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " 판매 가격"
        textField.addLeftPadding()
        textField.layer.borderWidth = 0.1
        textField.layer.cornerRadius = 5
        textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
        return textField
    }()
    
    private let productSaleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " 할인 금액"
        textField.addLeftPadding()
        textField.layer.borderWidth = 0.1
        textField.layer.cornerRadius = 5
        textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
        return textField
    }()
    
    private let productStockTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " 재고 수량"
        textField.addLeftPadding()
        textField.layer.borderWidth = 0.1
        textField.layer.cornerRadius = 5
        textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
        return textField
    }()
    
    private let textViewPlaceHolder = " 텍스트를 입력하세요"
    
    private lazy var productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 0.1
        textView.layer.cornerRadius = 5
        textView.setContentHuggingPriority(UILayoutPriority(50), for: .vertical)
        return textView
    }()
    
    //MARK: - View Initializer
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addUIComponents()
        setupLayout()
        textViewDefault()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("ProductListViewController Initialize error")
    }
    
    private func addUIComponents() {
        addSubview(mainScrollView)
        
        mainScrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(registCollectionView)
        mainStackView.addArrangedSubview(productInfoStackView)
        
        productNameTextField.delegate = self
        productSaleTextField.delegate = self
        productStockTextField.delegate = self
        productPriceTextField.delegate = self
        productDescriptionTextView.delegate = self
    }
    
    // MARK: - Setup Collection View Method
    
    private func setupLayout() {
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
    
    private func textViewDefault() {
        let text = productDescriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text == "" {
            productDescriptionTextView.text = textViewPlaceHolder
            productDescriptionTextView.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        }
    }
    
    func makeProduct() -> RegistrationProduct {
        return RegistrationProduct(name: productNameTextField.text ?? "",
                                   description: productDescriptionTextView.text ?? "",
                                   price: Double(productPriceTextField.text ?? "0") ?? 0,
                                   currency: "KRW",
                                   discountedPrice: Double(productSaleTextField.text ?? "0") ?? 0,
                                   stock: Int(productStockTextField.text ?? "0") ?? 0,
                                   secret: UserInfo.secret)
    }
    
    func configureProduct(product: ProductDetail) {
        productNameTextField.text = product.name
        productDescriptionTextView.text = product.description
        productPriceTextField.text = "\(product.price)"
        productSaleTextField.text = "\(product.discountedPrice)"
        productStockTextField.text = "\(product.stock)"
        if !productDescriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            productDescriptionTextView.textColor = .black
        }
    }
}

extension ProductRegistView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 15
    }
}

// MARK: - UITextViewDelegate Functions

extension ProductRegistView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray.withAlphaComponent(0.7)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        if characterCount > 700 {
            print("700자를 넘겼습니다.")
            return false
        }
        return true
    }
}
