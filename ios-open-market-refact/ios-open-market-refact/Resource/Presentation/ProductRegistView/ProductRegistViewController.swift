//
//  ProductRegistViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

enum ProductTextConditionAlert {
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
    private var product: ProductDetail?
    
    enum ViewMode {
        case add, edit
    }
    
    enum Section: Int {
        case image
    }
    
    private let registView = ProductRegistView()
    private let imagePicker = UIImagePickerController()
    private var viewMode = ViewMode.add
    
    private var isAppendable = true
    
    private lazy var dataSource: DataSource = configureDataSource()
    private lazy var snapshot: Snapshot = configureSnapshot()
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UIImage>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardUp),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDown),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    override func setupDefault() {
        view.backgroundColor = .systemBackground
        configureProduct()
        addUIComponents()
        setupLayout()
        setupNavigationBar()
        configureImagePicker()
        updateDataSource(data: [UIImage(named: "iconCamera.png") ?? UIImage()])
        registView.registCollectionView.delegate = self
    }
    
    override func addUIComponents() {
        view.addSubview(registView)
    }
    
    override func setupLayout() {
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
            self.navigationItem.title = "상품 등록"
        case .edit:
            self.navigationItem.title = "상품 수정"
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
        return DataSource(collectionView: registView.registCollectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductRegistCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? ProductRegistCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.removeImage = {
                switch self.viewMode {
                case .add:
                    self.deleteDataSource(image: itemIdentifier)
                case .edit:
                    AlertDirector(viewController: self).createErrorAlert(message: "사진은 수정이 불가합니다.")
                }
            }
            if self.isAppendable && indexPath.row == 0 {
                cell.hideDeleteImageButton()
            }
            cell.configureImage(data: itemIdentifier)
            return cell
        }
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
        guard let request = OpenMarketRequestDirector()
            .createPostRequest(product: input, images: productImages) else { return }
        
        NetworkManager().dataTask(with: request) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    AlertDirector(viewController: self)
                        .createProductPostSuccessAlert(message: "해당 상품을 등록 완료했습니다.") { [weak self] _ in
                            NotificationCenter.default.post(name: .addProductData,
                                                            object: self)
                            self?.refreshList?()
                            self?.navigationController?.popViewController(animated: true)
                        }
                }
            case .failure:
                DispatchQueue.main.async {
                    if images.isEmpty {
                        AlertDirector(viewController: self).createErrorAlert(message: "사진을 등록해 주세요")
                    }
                }
            }
        }
    }
    
    private func patchProduct(input: RegistrationProduct) {
        guard let product = product else { return }
        guard let request = OpenMarketRequestDirector().createPatchRequest(product: input,
                                                                           productNumber: product.id) else { return }
        
        NetworkManager().dataTask(with: request) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    AlertDirector(viewController: self).createProductPatchSuccessAlert(message: "해당 상품을 수정 완료했습니다.") { [weak self] _ in
                        NotificationCenter.default.post(name: .productDataDidChanged,
                                                        object: self)
                        self?.refreshList?()
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                AlertDirector(viewController: self).createErrorAlert(message: "상품 수정에 실패하였습니다.")
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
    
    @objc private func didTapDoneButton() {
        switch viewMode {
        case .add:
            let product = registView.makeProduct()
            if checkTextIsEmpty(product: product) == .success {
                postProduct(input: product)
            } else {
                let condition = checkTextIsEmpty(product: product).message
                AlertDirector(viewController: self).createErrorAlert(message: condition)
            }
        case .edit:
            let product = registView.makeProduct()
            if checkTextIsEmpty(product: product) == .success {
                patchProduct(input: product)
            } else {
                let condition = checkTextIsEmpty(product: product).message
                AlertDirector(viewController: self).createErrorAlert(message: condition)
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

// MARK: - UICollectionViewDelegate Function

extension ProductRegistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && isAppendable {
            switch viewMode {
            case .add:
                self.present(imagePicker, animated: true)
            case .edit:
                AlertDirector(viewController: self).createErrorAlert(message: "사진은 수정이 불가합니다.")
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
            right: 0.0)
        registView.mainScrollView.contentInset = contentInset
        registView.mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardDown() {
        let contentInset = UIEdgeInsets.zero
        registView.mainScrollView.contentInset = contentInset
        registView.mainScrollView.scrollIndicatorInsets = contentInset
    }
}
