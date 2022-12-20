//
//  ProductRegistViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

private enum ProductRegistViewControllerNameSpace {
    static let addViewNavigationTitle = "상품 등록"
    static let editViewNavigationTitle = "상품 수정"
    static let editImageMessage = "사진은 수정이 불가합니다."
    static let successRegistMessage = "해당 상품을 등록 완료했습니다."
    static let registImageMessage = "사진을 등록해 주세요"
    static let successEditMessage = "해당 상품을 수정 완료했습니다."
    static let editFailureMessage = "상품 수정에 실패하였습니다."
}

private enum ProductTextConditionAlert {
    case invalidName
    case invalidPrice
    case invalidStock
    case success
    
    var message: String {
        switch self {
        case .invalidName:
            return "이름을 올바르게 입력해 주세요"
        case .invalidPrice:
            return "가격을 올바르게 입력해 주세요"
        case .invalidStock:
            return "재고를 올바르게 입력해 주세요"
        case .success:
            return "상품 등록 완료"
        }
    }
}

final class ProductRegistViewController: SuperViewControllerSetting {
    
    enum ViewMode {
        case add
        case edit
    }
    
    enum Section: Int {
        case image
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UIImage>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
    private lazy var dataSource: DataSource = configureDataSource()
    private lazy var snapshot: Snapshot = configureSnapshot()
    
    private let registView = ProductRegistView()
    private let imagePicker = UIImagePickerController()
    private var viewMode = ViewMode.add
    private var isAppendable = true
    private var product: ProductDetail?
    
    var refreshList: (() -> Void)?
    
    //MARK: - ViewController Initializer
    
    init(product: ProductDetail?) {
        self.product = product
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("ProductRegistViewController Initialize error")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardUp),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDown),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    //MARK: - Setup ViewController method
    
    override func setupDefault() {
        super.setupDefault()
        view.backgroundColor = .systemBackground
        configureProduct()
        setupNavigationBar()
        configureImagePicker()
        updateDataSource(data: [UIImage(named: "iconCamera.png") ?? UIImage()])
        registView.registCollectionView.delegate = self
    }
    
    override func addUIComponents() {
        super.addUIComponents()
        view.addSubview(registView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        NSLayoutConstraint.activate([
            registView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            registView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            registView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            registView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        switch viewMode {
        case .add:
            self.navigationItem.title = ProductRegistViewControllerNameSpace.addViewNavigationTitle
        case .edit:
            self.navigationItem.title = ProductRegistViewControllerNameSpace.editViewNavigationTitle
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDoneButton)
        )
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    private func configureDataSource() -> DataSource {
        let cell = UICollectionView.CellRegistration<ProductRegistCollectionViewCell, UIImage> { cell, indexPath, item in
            cell.removeImage = {
                switch self.viewMode {
                case .add:
                    self.deleteDataSource(image: item)
                case .edit:
                    AlertDirector(viewController: self).createErrorAlert(
                        message: ProductRegistViewControllerNameSpace.editImageMessage
                    )
                }
            }
            if self.isAppendable && indexPath.row == 0 {
                cell.hideDeleteImageButton()
            }
            cell.configureImage(data: item)
        }
        
        let dataSource = DataSource(collectionView: registView.registCollectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cell,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        return dataSource
    }
    
    private func configureSnapshot() -> Snapshot {
        Snapshot()
    }
    
    private func updateDataSource(data: [UIImage]) {
        snapshot.appendSections([.image])
        snapshot.appendItems(data)
        
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
    
    private func appendDataSource(data: UIImage) {
        snapshot.appendItems([data])
        
        if snapshot.numberOfItems > 5 {
            guard let first = snapshot.itemIdentifiers.first else { return }
            
            snapshot.deleteItems([first])
            isAppendable = false
        }
        
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
    
    private func deleteDataSource(image: UIImage) {
        snapshot.deleteItems([image])
        
        if !isAppendable {
            guard let first = snapshot.itemIdentifiers.first else { return }
            
            let insertImage = UIImage(named: "iconCamera.png") ?? UIImage()
            
            snapshot.insertItems([insertImage], beforeItem: first)
            isAppendable = true
        }
        
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
    
    private func postProduct(input: RegistrationProduct) {
        var images = snapshot.itemIdentifiers
        
        if isAppendable {
            images.removeFirst()
        }
        
        let productImages = images.map {
            ProductImage(name: $0.description, data: $0.compress() ?? Data(), type: "png")
        }
        
        guard let request = OpenMarketRequestDirector().createPostRequest(
            product: input,
            images: productImages
        ) else { return }
        
        NetworkManager().dataTask(with: request) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    AlertDirector(viewController: self)
                        .createProductPostSuccessAlert(
                            message: ProductRegistViewControllerNameSpace.successRegistMessage
                        ) { [weak self] _ in
                            NotificationCenter.default.post(
                                name: .addProductData,
                                object: self
                            )
                            
                            self?.refreshList?()
                            self?.navigationController?.popViewController(animated: true)
                        }
                }
            case .failure:
                DispatchQueue.main.async {
                    if images.isEmpty {
                        AlertDirector(viewController: self).createErrorAlert(
                            message: ProductRegistViewControllerNameSpace.registImageMessage
                        )
                    }
                }
            }
        }
    }
    
    private func patchProduct(input: RegistrationProduct) {
        guard let product = product else { return }
        guard let request = OpenMarketRequestDirector().createPatchRequest(
            product: input,
            productNumber: product.id
        ) else { return }
        
        NetworkManager().dataTask(with: request) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    AlertDirector(viewController: self).createProductPatchSuccessAlert(
                        message: ProductRegistViewControllerNameSpace.successEditMessage
                    ) { [weak self] _ in
                        NotificationCenter.default.post(
                            name: .productDataDidChanged,
                            object: self
                        )
                        
                        self?.refreshList?()
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                AlertDirector(viewController: self).createErrorAlert(
                    message: ProductRegistViewControllerNameSpace.editFailureMessage
                )
                
                print(error.localizedDescription)
                break
            }
        }
    }
    
    private func configureProduct() {
        guard let product = product else { return }
        
        registView.configureProduct(product: product)
        viewMode = .edit
        
        DispatchQueue.main.async {
            product.images.forEach { image in
                guard let url = NSURL(string: image.url) else { return }
                
                ImageCache.shared.load(url: url) { image in
                    guard let image = image else { return }
                    
                    self.appendDataSource(data: image)
                }
            }
        }
    }
    
    private func checkProductInfomation(product: RegistrationProduct, completion: @escaping () -> Void) {
        
        if checkTextIsEmpty(product: product) == .success {
            completion()
        } else {
            let condition = checkTextIsEmpty(product: product).message
            
            AlertDirector(viewController: self).createErrorAlert(message: condition)
        }
    }
    
    @objc private func didTapDoneButton() {
        switch viewMode {
        case .add:
            let product = registView.makeProduct()
            checkProductInfomation(product: product) {
                self.postProduct(input: product)
            }
        case .edit:
            let product = registView.makeProduct()
            checkProductInfomation(product: product) {
                self.patchProduct(input: product)
            }
        }
    }
    
    private func checkTextIsEmpty(product: RegistrationProduct) -> ProductTextConditionAlert {
        guard product.name != "" else { return ProductTextConditionAlert.invalidName }
        guard product.price != 0 else  { return ProductTextConditionAlert.invalidPrice }
        guard product.stock != 0 else  { return ProductTextConditionAlert.invalidStock }
        
        return ProductTextConditionAlert.success
    }
}

// MARK: - UIImagePicker & UINavigation ControllerDelegate Function

extension ProductRegistViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        appendDataSource(data: selectedImage)
        dismiss(animated: true)
    }
}

// MARK: - UICollectionView Delegate Function

extension ProductRegistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && isAppendable {
            switch viewMode {
            case .add:
                self.present(imagePicker, animated: true)
            case .edit:
                AlertDirector(viewController: self).createErrorAlert(
                    message: ProductRegistViewControllerNameSpace.editImageMessage
                )
            }
        }
    }
}

// MARK: - KeyBoard Objc Functions

extension ProductRegistViewController {
    @objc private func keyboardUp(notification:NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0
        )
        
        registView.mainScrollView.contentInset = contentInset
        registView.mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardDown() {
        let contentInset = UIEdgeInsets.zero
        
        registView.mainScrollView.contentInset = contentInset
        registView.mainScrollView.scrollIndicatorInsets = contentInset
    }
}
