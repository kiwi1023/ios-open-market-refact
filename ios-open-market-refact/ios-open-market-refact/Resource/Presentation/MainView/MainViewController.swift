//
//  MainViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/16.
//

import UIKit

private enum MainViewControllerNameSpace {
    static let appTitle = "My Market🏪"
    static let initialPageInfo: (pageNumber: Int, itemsPerPage: Int) = (1, 20)
    static let getDataErrorMassage = "데이터를 받아오지 못했습니다."
}

final class MainViewController: SuperViewControllerSetting {
    typealias InitialPageInfo = (pageNumber: Int, itemsPerPage: Int)
    
    enum Section {
        case main
    }
    
    private let mainViewModel = MainViewModel()
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Product>
    
    private lazy var dataSource: DataSource? = configureDataSource()
    private lazy var bannerView = MainBannerView()
    private let productMiniListView = ProductMiniListView()
    
    //MARK: - Setup ViewController Method
    
    override func setupDefault() {
        view.backgroundColor = .systemBackground
        productMiniListView.titleStackView.moreButtonDelegate = self
        productMiniListView.miniListCollectionView?.delegate = self
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func addUIComponents() {
        view.addSubview(bannerView)
        view.addSubview(productMiniListView)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.sizeToFit()
        navigationItem.title = MainViewControllerNameSpace.appTitle
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:  30),
            bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            bannerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            productMiniListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productMiniListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productMiniListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            productMiniListView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func bind() {
        let miniListFetchAction = Observable<(InitialPageInfo)>(MainViewControllerNameSpace.initialPageInfo)
        let bannerImageLoadAction = Observable(MainViewModel.MainViewAction.bannerImageLoad)
                                                                
        let output = mainViewModel.transform(input: .init(
            productMiniListFetchAction: miniListFetchAction,
            bannerImageLoadAction: bannerImageLoadAction
        ))
        
        output.productListOutput.subscribe { list in
            DispatchQueue.main.async {
                self.updateDataSource(data: list)
            }
        }
        
        output.bannerImagesOutput.subscribe { bannerUrls in
            DispatchQueue.main.async { [weak self] in
                self?.bannerView.bind(imageUrls: bannerUrls)
            }
        }
    }
}

//MARK: - Setup CollectionView Method

extension MainViewController {
    
    private func configureDataSource() -> DataSource? {
        guard let miniListCollectionView = productMiniListView.miniListCollectionView else {
            return nil
        }
        
        let cellRegistration = UICollectionView.CellRegistration<ProductMiniListViewCell, Product> { cell, indexPath, item in
            cell.configure(data: item)
        }
        
        let dataSource = DataSource(collectionView: miniListCollectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
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

//MARK: - More Button AddTargeting delegate

protocol MoreButtonTapDelegate {
    
    func moreButtonAddGesture()
}

extension MainViewController: MoreButtonTapDelegate {
    
    func moreButtonAddGesture() {
        navigationController?.pushViewController(ProductListViewController(), animated: true)
    }
}

//MARK: - MiniListViewController delegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailViewController = ProductDetailViewController()
        
        guard let productId = dataSource?.itemIdentifier(for: indexPath)?.id else { return }
        
        productDetailViewController.receiveProductNumber(productNumber: productId)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}
