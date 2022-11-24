//
//  ProductRegistViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductRegistViewController: UIViewController {
    
    enum ViewMode {
        case add, edit
    }
    
    enum Section: Int {
        case image
    }
    
    private let registView = ProductRegistView()
    private let imagePicker = UIImagePickerController()
    private var viewMode = ViewMode.add
    
    private var appendable = true
    
    private lazy var dataSource: DataSource = configureDataSource()
    private lazy var snapshot: Snapshot = configureSnapshot()
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UIImage>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
    //MARK: - ViewController Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("ProductRegistViewController Initialize error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupDefault() {
        view.backgroundColor = .systemBackground
        
        addUIComponents()
        setupLayout()
        setupNavigationBar()
        configureImagePicker()
        updateDataSource(data: [UIImage(named: "iconCamera.png") ?? UIImage()])
        
        registView.registCollectionView.delegate = self
    }
    
    private func addUIComponents() {
        view.addSubview(registView)
    }
    
    private func setupLayout() {
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
        
        let dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: registView.registCollectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductRegistCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductRegistCollectionViewCell else { return UICollectionViewCell() }
            
            cell.removeImage = {
                self.deleteDataSource(image: itemIdentifier)
            }
            if self.appendable && indexPath.row == 0 {
                cell.hideDeleteImageButton()
            }
            cell.configureImage(data: itemIdentifier)
            return cell
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
            appendable = false
        }
        
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
    
    private func deleteDataSource(image: UIImage) {
        snapshot.deleteItems([image])
        
        if !appendable {
            guard let first = snapshot.itemIdentifiers.first else { return }
            let insertImage = UIImage(named: "iconCamera.png") ?? UIImage()
            snapshot.insertItems([insertImage], beforeItem: first)
            appendable = true
        }
        
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
    
    private func postProduct(input: RegistrationProduct) {
        var images = snapshot.itemIdentifiers
        if appendable {
            images.removeFirst()
        }
        let productImages = images.map {
            ProductImage(name: $0.description, data: $0.compress() ?? Data(), type: "png")
        }
        guard let request = OpenMarketRequestDirector().createPostRequest(product: input, images: productImages) else { return }
        NetworkManager().dataTask(with: request) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("성공")
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure:
                DispatchQueue.main.async {
                    //self.showAlert(title: "서버 통신 실패", message: "데이터를 받아오지 못했습니다.")
                    print("실패")
                }
            }
        }
    }
    
    func changeToEditMode() {
        viewMode = .edit
    }
    
    @objc private func didTapDoneButton() {
        switch viewMode {
        case .add:
            let product = registView.makeProduct()
            postProduct(input: product)
        case .edit:
//            let product = registView.makeProduct()
//            patchProduct(input: product)
            print("patch기능 추가해주세요~!")
        }
        
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
        if indexPath.row == 0 && appendable {
            self.present(imagePicker, animated: true)
        }
    }
}

// MARK: - KeyBoard Objc Functions

extension ProductRegistViewController {
    @objc func keyboardUp(notification:NSNotification) {
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
    
    @objc func keyboardDown() {
        let contentInset = UIEdgeInsets.zero
        registView.mainScrollView.contentInset = contentInset
        registView.mainScrollView.scrollIndicatorInsets = contentInset
    }
}

