//
//  ProductRegistViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductRegistViewController: UIViewController {
    
    enum Section: Int {
        case image
    }
    
    private let registView = ProductRegistView()
    private let imagePicker = UIImagePickerController()
    
    private var productImages = [UIImage(systemName: "plus") ?? UIImage()]
    
    private var selectedImageNumber: Int?
    
    private lazy var dataSource: DataSource = configureDataSource()
    private var snapshot = Snapshot()
    
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
    
    private func setupDefault() {
        view.backgroundColor = .systemBackground
        
        addUIComponents()
        setupLayout()
        setupNavigationBar()
        configureImagePicker()
        updateDataSource(data: productImages)
        setupLongGestureRecognizerOnCollection()

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
        self.navigationItem.title = "상품 등록"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton)
        )
        
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
        let cellRegistration = UICollectionView.CellRegistration<ProductRegistCollectionViewCell, UIImage> { cell, indexPath, item in
            cell.configure(data: item)
        }
        
        return UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: registView.registCollectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
    }
    
    private func updateDataSource(data: [UIImage]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([.image])
        if data.count > 5 {
            var justData: [UIImage] = []
            for index in 1...data.count-1 {
                justData.append(data[index])
            }
            snapshot.appendItems(justData)
        } else {
            snapshot.appendItems(data)
        }
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
    
    private func appendImage(image: UIImage) {
        productImages.insert(image, at: 1)
        updateDataSource(data: productImages)
    }
    
    private func changeImage(image: UIImage) {
        guard let index = selectedImageNumber else { return }
        productImages[index] = image
        updateDataSource(data: productImages)
    }
    
    @objc private func didTapCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapDoneButton() {
        print("didTapDoneButton!")
    }
}

// MARK: - UIImagePicker & UINavigation ControllerDelegate Function

extension ProductRegistViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        if selectedImageNumber == 0 {
            appendImage(image: selectedImage)
        } else {
            changeImage(image: selectedImage)
        }
        dismiss(animated: true)
    }
}

// MARK: - UICOllectionViewDelegate Function

extension ProductRegistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageNumber = indexPath.row
        self.present(imagePicker, animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate Function

extension ProductRegistViewController: UIGestureRecognizerDelegate {
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressedGesture.minimumPressDuration = 1
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        registView.registCollectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc private func handleLongPress(_ guesture: UILongPressGestureRecognizer) {
        let point = guesture.location(in: registView.registCollectionView)
        guard let indexPath = registView.registCollectionView.indexPathForItem(at: point) else { return }
        if guesture.state == UIGestureRecognizer.State.began && indexPath.row != 0 {
            longPressAction(index: indexPath.item, sourceView: guesture.view)
        }
    }
    
    private func longPressAction(index: Int, sourceView: UIView?) {
        let alertController = UIAlertController(title: "알림", message: "삭제하시겠습니까?", preferredStyle: .alert)
        alertController.modalPresentationStyle = .popover
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .default)
        let deleteAction = UIAlertAction(title: "삭제",
                                         style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.productImages.remove(at: index)
            self.updateDataSource(data: self.productImages)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true)
    }
}

