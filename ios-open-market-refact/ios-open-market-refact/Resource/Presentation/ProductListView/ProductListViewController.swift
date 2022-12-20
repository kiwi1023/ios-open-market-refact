//
//  ProductListViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
//

import UIKit

final class ProductListViewController: SuperViewControllerSetting {
    
    //MARK: ProductListView NameSpace
    
    private enum ProductListViewControllerNameSpace {
        static let initialPageInfo: (pageNumber: Int, itemsPerPage: Int) = (1, 10)
        static let navigationTitle = "상품목록"
        static let searchControllerPlaceHolder = "검색해보세용"
        static let emptySearchState = ""
        static let registButtonColor = "RegistButtonColor"
        static let getDataErrorMassage = "데이터를 받아오지 못했습니다."
    }
    
    //MARK: CollectionView Properties
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Product>

    private var selectedIndexPath: IndexPath?
    
    enum Section {
        case main
    }
    
    enum FetchType {
        case update
        case add
    }
    
    private let pageState = Observable<(
        pageNumber: Int,
        itemsPerPage: Int,
        fetchType: FetchType)
    >((
        ProductListViewControllerNameSpace.initialPageInfo.pageNumber,
        ProductListViewControllerNameSpace.initialPageInfo.itemsPerPage,
        .update
    ))
    private let filteringState = Observable<String>("")
    
    private let productListViewModel = ProductListViewModel(networkAPI: NetworkManager())
    
    private lazy var dataSource: DataSource? = configureDataSource()
    private lazy var snapshot: Snapshot = configureSnapshot()
    
    //MARK: View
    private lazy var refreshController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        return refreshControl
    }()
    
    private let productListView = ProductListView()
    
    private let registProductImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(named: ProductListViewControllerNameSpace.registButtonColor)
        return imageView
    }()
    
    //MARK: - View LifeCycle Method
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: - View Default Setup Method
    
    override func setupDefault() {
        view.backgroundColor = .systemBackground
        productListView.mainCollectionView?.delegate = self
        productListView.mainCollectionView?.refreshControl = refreshController
        addUIComponents()
        setupLayout()
        setupNavigationBar()
        setupImageViewGesture()
        registerProductNotification()
        bind()
    }
    
    override func addUIComponents() {
        view.addSubview(productListView)
        view.addSubview(registProductImageView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            productListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            registProductImageView.widthAnchor.constraint(equalToConstant: 50),
            registProductImageView.heightAnchor.constraint(equalToConstant: 50),
            registProductImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            registProductImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ProductListViewControllerNameSpace.navigationTitle
        navigationItem.largeTitleDisplayMode = .automatic
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = ProductListViewControllerNameSpace.searchControllerPlaceHolder
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    private func setupImageViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRegistButton))
        registProductImageView.image = UIImage(systemName: "plus.circle.fill")
        registProductImageView.addGestureRecognizer(tapGesture)
        registProductImageView.isUserInteractionEnabled = true
    }
    
    @objc private func didTapRegistButton() {
        navigationController?.pushViewController(ProductRegistViewController(), animated: true)
    }
    
    //MARK: - Data Source, Snapshot Update Method
    
    private func bind () {
        
        let output = productListViewModel.transform(input: .init(
            productListPageInfoUpdateAction: pageState,
            filteringStateUpdateAction: filteringState
        ))
        
        output.productListOutput.subscribe { [self] productList in
            switch pageState.value.fetchType {
            case .update :
                snapshot.deleteAllItems()
                snapshot.appendSections([.main])
                snapshot.appendItems(productList)
            case .add :
                snapshot.appendItems(productList)
            }
            DispatchQueue.main.async {
                self.dataSource?.apply(self.snapshot, animatingDifferences: false, completion: nil)
            }
        }
        
        output.filteredListOutput.subscribe { filteredList in
            self.filteredDataSource(data: filteredList)
        }
        
        productListViewModel.onErrorHandling = { failure in
            AlertDirector(viewController: self).createErrorAlert(
                message: ProductListViewControllerNameSpace.getDataErrorMassage
            )
        }
    }
    
    func filteredDataSource(data: [Product]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        
        DispatchQueue.main.async {
            self.dataSource?.apply(self.snapshot, animatingDifferences: false, completion: nil)
        }
    }
    
    //MARK: - Setup CollectionView Method
    
    private func configureSnapshot() -> Snapshot {
        Snapshot()
    }
    
    private func configureDataSource() -> DataSource? {
        guard let mainCollectionView = productListView.mainCollectionView else { return nil }
        
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
    
    //MARK: - Product Refresh Method
    
    private func registerProductNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateList),
            name: .addProductData,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didProductDataChanged),
            name: .productDataDidChanged,
            object: nil
        )
    }
    
    @objc private func didProductDataChanged() {
        pageState.value.fetchType = .update
        scrollToSelectedIndex()
    }
    
    @objc private func refreshList() {
        let initialPageInfo = ProductListViewControllerNameSpace.initialPageInfo
        pageState.value = (initialPageInfo.pageNumber, initialPageInfo.itemsPerPage, .update)
        refreshController.endRefreshing()
    }
    
    @objc private func updateList() {
        refreshList()
        self.scrollToTop()
    }
    
    private func scrollToTop() {
        productListView.mainCollectionView?.scrollToItem(
            at: IndexPath(item: -1, section: 0),
            at: .init(rawValue: 0),
            animated: true
        )
    }
    
    private func scrollToSelectedIndex() {
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        productListView.mainCollectionView?.scrollToItem(
            at: selectedIndexPath,
            at: .init(rawValue: 0),
            animated: true
        )
    }
}

// MARK: - CollectionView delegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailViewController = ProductDetailViewController()
        
        guard let productId = dataSource?.itemIdentifier(for: indexPath)?.id else { return }
        
        self.selectedIndexPath = indexPath
        productDetailViewController.receiveProductNumber(productNumber: productId)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let position = scrollView.contentOffset.y
        
        guard let height = productListView.mainCollectionView?.contentSize.height,
              let boundHeight = productListView.mainCollectionView?.bounds.size.height else { return }
        
        if position > (height - boundHeight + 100) {
            pageState.value = (pageState.value.pageNumber + 1, pageState.value.itemsPerPage, .add)
        }
    }
}

//MARK: - SearchBar Controller

extension ProductListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        if text == ProductListViewControllerNameSpace.emptySearchState {
            //pageState.value = (pageState.value.pageNumber, pageState.value.itemsPerPage, .update)
            self.scrollToTop()
        } else {
            sortingProduct(text: text)
        }
    }
    
    private func sortingProduct(text: String) {
        filteringState.value = text
    }
}

extension ProductListViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        refreshList()
    }
}
