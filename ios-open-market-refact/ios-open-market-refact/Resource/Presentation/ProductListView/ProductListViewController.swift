//
//  ProductListViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
//

import UIKit

final class ProductListViewController: SuperViewControllerSetting {
    
    private var pageInfo: (pageNumber: Int, itemsPerPage: Int) = (1, 10)
    private var productList: [Product] = []
    private var selectedIndexPath: IndexPath?
    
    enum Section {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Product>
    
    private lazy var dataSource: DataSource? = configureDataSource()
    private lazy var snapshot: Snapshot = configureSnapshot()
    
    //MARK: View
    private lazy var refreshController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        //refreshControl.addTarget(self, action: #selector(refreshList) , for: .valueChanged)
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var mainView = ProductListView()
    
    private let registProductImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(red: 1, green: 126/255, blue: 55/255, alpha: 1)
        return imageView
    }()
    
    //MARK: - View LifeCycle Method
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    //MARK: - View Default Setup Method
    
    override func setupDefault() {
        view.backgroundColor = .systemBackground
        mainView.mainCollectionView?.delegate = self
        mainView.mainCollectionView?.refreshControl = refreshController
        addUIComponents()
        setupLayout()
        fetchedProductList()
        setupNavigationBar()
        setupImageViewGesture()
        registerProductNotification()
    }
    
    override func addUIComponents() {
        view.addSubview(mainView)
        view.addSubview(registProductImageView)
    }
    
    override func setupLayout() {
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
        searchController.searchResultsUpdater = self
        //searchController.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    private func setupImageViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRegistButton))
        registProductImageView.image = UIImage(systemName: "plus.circle.fill")
        registProductImageView.addGestureRecognizer(tapGesture)
        registProductImageView.isUserInteractionEnabled = true
    }
    
    @objc private func didTapSearchingButton() {
        print("didTapSearchingButton!")
    }
    
    @objc private func didTapRegistButton() {
        navigationController?.pushViewController(ProductRegistViewController(product: nil), animated: true)
    }
    
    private func fetchedProductList() {
        guard let productListGetRequest = OpenMarketRequestDirector()
            .createGetRequest(
                pageNumber: pageInfo.pageNumber,
                itemsPerPage: pageInfo.itemsPerPage
            ) else {
            return
        }
        
        NetworkManager().dataTask(with: productListGetRequest) { result in
            switch result {
            case .success(let data):
                guard let fetchedList = JsonDecoderManager.shared.decode(from: data, to: ProductList.self) else {
                    return
                }
                DispatchQueue.main.async {
                    self.updateDataSource(data: fetchedList.pages)
                }
                
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "데이터 로드 오류")
            }
        }
    }
    
    private func addingProductList() {
        guard let productListGetRequest = OpenMarketRequestDirector()
            .createGetRequest(
                pageNumber: pageInfo.pageNumber,
                itemsPerPage: pageInfo.itemsPerPage
            ) else {
            return
        }
        
        NetworkManager().dataTask(with: productListGetRequest) { result in
            switch result {
            case .success(let data):
                guard let fetchedList = JsonDecoderManager.shared.decode(from: data, to: ProductList.self) else {
                    return
                }
                DispatchQueue.main.async {
                    self.appendDataSource(data: fetchedList.pages)
                }
                
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "데이터 로드 오류")
            }
        }
    }
    
    func updateDataSource(data: [Product]) {
        productList = data
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    func appendDataSource(data: [Product]) {
        productList += data
        snapshot.appendItems(data)
        DispatchQueue.main.async {
            self.dataSource?.apply(self.snapshot, animatingDifferences: false, completion: nil)
        }
    }
    
    func filteredDataSource(data: [Product]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    @objc private func refreshList() {
        print("새로고침띠")
        pageInfo = (1,10)
        fetchedProductList()
        refreshController.endRefreshing() // 새로고침 이벤트 종료
    }
    
    //MARK: - Setup CollectionView Method
    
    private func configureSnapshot() -> Snapshot {
        Snapshot()
    }
    
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
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    private func registerProductNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateList),
                                               name: .addProductData,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didProductDataChanged),
                                               name: .productDataDidChanged,
                                               object: nil)
    }
    
    @objc private func updateList() {
        refreshList()
        self.scrollToTop()
    }
    
    @objc private func didProductDataChanged() {
        fetchedProductList()
    }
    
    private func scrollToSelectedIndex() {
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        mainView.mainCollectionView?.scrollToItem(at: selectedIndexPath, at: .init(rawValue: 0), animated: true)
    }
    
    func scrollToTop() {
        mainView.mainCollectionView?.scrollToItem(at: IndexPath(item: -1, section: 0), at: .init(rawValue: 0), animated: true)
    }
}

// MARK: - CollectionView delegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailViewController = ProductDetailViewController()
        guard let productId = dataSource?.itemIdentifier(for: indexPath)?.id else {
            return
        }
        self.selectedIndexPath = indexPath
        
        productDetailViewController.receiveProductNumber(productNumber: productId)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let position = scrollView.contentOffset.y
        guard let height = mainView.mainCollectionView?.contentSize.height,
              let boundHeight = mainView.mainCollectionView?.bounds.size.height else {
            return
        }
        print("position : \(position)")
        if position > (height - boundHeight + 100) {
            pageInfo.pageNumber += 1
            addingProductList()
        }
    }
}

//MARK: - SearchBar Controller

extension ProductListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        if text == "" {
            fetchedProductList()
        } else {
            sortingProduct(text: text)
        }
    }
    
    private func sortingProduct(text: String) {
        filteredDataSource(data: productList.filter({ product in
            product.name.lowercased().contains(text)
        }))
    }
}
