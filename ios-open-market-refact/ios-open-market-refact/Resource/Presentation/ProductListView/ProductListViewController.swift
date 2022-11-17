//
//  ProductListViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
//

import UIKit

final class ProductListViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Product>

    private lazy var dataSource: DataSource? = configureDataSource()

    private lazy var mainView = ProductListView()
    private let registProductImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(red: 1, green: 126/255, blue: 55/255, alpha: 1)
        return imageView
    }()
    
    //MARK: - ViewController Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupDefault()
        updateDataSource(data: ProductListView.sampleData)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("ProductListViewController Initialize error")
    }
    
    //MARK: - View LifeCycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - View Default Setup Method
    
    private func setupDefault() {
        view.backgroundColor = .systemBackground
        mainView.mainCollectionView?.delegate = self
        addUIComponents()
        setupLayout()
        setupNavigationBar()
        
        registProductImageView.image = UIImage(systemName: "plus.circle.fill")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRegistButton))
        registProductImageView.addGestureRecognizer(tapGesture)
        registProductImageView.isUserInteractionEnabled = true
    }
    
    private func addUIComponents() {
        view.addSubview(mainView)
        view.addSubview(registProductImageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            registProductImageView.widthAnchor.constraint(equalToConstant: 50),
            registProductImageView.heightAnchor.constraint(equalToConstant: 50),
            registProductImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            registProductImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "상품목록"
        navigationItem.largeTitleDisplayMode = .automatic
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색해보세용"
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    @objc private func didTapSearchingButton() {
        print("didTapSearchingButton!")
    }
    
    @objc private func didTapRegistButton() {
        navigationController?.pushViewController(ProductRegistViewController(), animated: true)
    }
    
    //MARK: - Setup CollectionView Method
    
    private func configureDataSource() -> DataSource? {
        guard let mainCollectionView = mainView.mainCollectionView else {
            return nil
        }
        
        let cellRegistration = UICollectionView.CellRegistration<ProductListViewCell, Product> { cell, indexPath, item in
            cell.configure(data: item)
        }
        
        let dataSource = DataSource(collectionView: mainCollectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        return dataSource
    }
    
    func updateDataSource(data: [Product]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: false, completion: nil)
    }
}
// MARK: - CollectionView delegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailViewController = ProductDetailViewController()
        //pushViewController(productDetailViewController, animated: true)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

//MARK: - SearchBar Controller

extension ProductListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        if text == "" {
            updateDataSource(data: ProductListView.sampleData)
        } else {
           updateDataSource(data: ProductListView.sampleData.filter({ product in
                product.name.lowercased().contains(text)
            }))
        }
    }
}
