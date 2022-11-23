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
    
    @objc private func didTapCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapDoneButton() {
        print("didTapDoneButton!")
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

// MARK: - UICOllectionViewDelegate Function

extension ProductRegistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && appendable {
            self.present(imagePicker, animated: true)
        }
    }
}
