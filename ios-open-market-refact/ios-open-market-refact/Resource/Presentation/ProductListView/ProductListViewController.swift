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
        
        addUIComponents()
        setupLayout()
        setupNavigationBar()
    }
    
    private func addUIComponents() {
        view.addSubview(mainView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "상품목록"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearchingButton)
        )
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색해보세용"
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self

    }
    
    @objc func didTapSearchingButton() {
        print("didTapSearchingButton!")
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
