//
//  ProductRegistViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductRegistViewController: SuperViewControllerSetting {
    
    //MARK: ProductRegistViewController NameSpace
    
    private enum ProductRegistViewControllerNameSpace {
        static let addViewNavigationTitle = "상품 등록"
        static let editViewNavigationTitle = "상품 수정"
        static let editImageMessage = "사진은 수정이 불가합니다."
        static let successRegistMessage = "해당 상품을 등록 완료했습니다."
        static let registImageMessage = "사진을 등록해 주세요"
        static let successEditMessage = "해당 상품을 수정 완료했습니다."
        static let editFailureMessage = "상품 수정에 실패하였습니다."
        static let dataLoadFailureMessage = "데이터를 불러오지 못했습니다."
        static let defaultCameraImageName = "iconCamera.png"
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
    
    //MARK: CollectionView Properties
    
    enum Section: Int {
        case image
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UIImage>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
    private lazy var dataSource: DataSource = configureDataSource()
    private lazy var snapshot: Snapshot = configureSnapshot()
    
    //MARK: ViewModel
    
    private let productRegistViewModel = ProductRegistViewModel()
    
    private let postAction = Observable<(RegistrationProduct?, [ProductImage])>((nil, []))
    private let patchAction = Observable<(RegistrationProduct?)>(nil)
    
    var refreshList: (() -> Void)?
    
    //MARK: View
    
    enum ViewMode {
        case add
        case edit
    }
    
    private var viewMode = ViewMode.add
    private var isAppendable = true
    
    private let productRegistView = ProductRegistView()
    private let imagePicker = UIImagePickerController()
    
    //MARK: - ViewController Initializer
    
    override func viewWillAppear(_ animated: Bool) {
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
        setupNavigationBar()
        configureImagePicker()
        collectionViewSetup()
        bind()
    }
    
    override func addUIComponents() {
        super.addUIComponents()
        
        view.addSubview(productRegistView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        NSLayoutConstraint.activate([
            productRegistView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productRegistView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productRegistView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productRegistView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    
    private func collectionViewSetup() {
        
        updateDataSource(data: [UIImage(named: ProductRegistViewControllerNameSpace.defaultCameraImageName) ?? UIImage()])
        productRegistView.registCollectionView.delegate = self
    }
    
    private func configureDataSource() -> DataSource {
        
        let cell = UICollectionView.CellRegistration<ProductRegistCollectionViewCell, UIImage> { [weak self] cell, indexPath, item in
            guard let self = self else { return }
            
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
        
        let dataSource = DataSource(collectionView: productRegistView.registCollectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cell,
                for: indexPath,
                item: itemIdentifier
            )
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
            
            let insertImage = UIImage(named: ProductRegistViewControllerNameSpace.defaultCameraImageName) ?? UIImage()
            
            snapshot.insertItems([insertImage], beforeItem: first)
            isAppendable = true
        }
        
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
    
    private func makeProductImages() -> [ProductImage] {
        
        var images = snapshot.itemIdentifiers
        
        if isAppendable {
            images.removeFirst()
        }
        
        return images.map {
            ProductImage(
                name: $0.description,
                data: $0.compress() ?? Data(),
                type: "png"
            )
        }
    }
    
    func configureProduct(product: ProductDetail) {
        
        productRegistViewModel.configure(id: product.id)
        productRegistView.configureProduct(product: product)
        viewMode = .edit
        
        DispatchQueue.main.async {
            product.images.forEach { image in
                guard let url = NSURL(string: image.url) else { return }
                
                ImageCache.shared.load(url: url) { [weak self] image in
                    guard let self = self,
                          let image = image else { return }
                    
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
    
    private func bind() {
        
        let input = ProductRegistViewModel.Input(postAction: postAction, patchAction: patchAction)
        let output = self.productRegistViewModel.transform(input: input)
        
        output.doneAction.subscribe { [weak self] isAction in
            guard let self = self else { return }
            
            if isAction {
                DispatchQueue.main.async {
                    self.refreshList?()
                    self.navigationController?.popViewController(animated: true)
                    
                    switch self.viewMode {
                    case .add:
                        NotificationCenter.default.post(name: .addProductData,
                                                        object: self)
                    case .edit:
                        NotificationCenter.default.post(name: .productDataDidChanged,
                                                        object: self)
                    }
                }
            }
        }
        
        productRegistViewModel.onErrorHandling = { [weak self] failure in
            guard let self = self else { return }
            
            AlertDirector(viewController: self).createErrorAlert(
                message: ProductRegistViewControllerNameSpace.dataLoadFailureMessage
            )
        }
    }
    
    @objc private func didTapDoneButton() {
        
        let product = productRegistView.makeProduct()
        let images = makeProductImages()
        
        checkProductInfomation(product: product) { [weak self] in
            guard let self = self else { return }
            
            switch self.viewMode {
            case .add:
                self.postAction.value = (product, images)
            case .edit:
                self.patchAction.value = (product)
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
        
        productRegistView.mainScrollView.contentInset = contentInset
        productRegistView.mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardDown() {
        let contentInset = UIEdgeInsets.zero
        
        productRegistView.mainScrollView.contentInset = contentInset
        productRegistView.mainScrollView.scrollIndicatorInsets = contentInset
    }
}
