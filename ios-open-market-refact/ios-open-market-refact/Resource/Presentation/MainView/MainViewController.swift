//
//  MainViewController.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/11/16.
//

import UIKit

final class MainViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Product>
    
    private lazy var dataSource: DataSource? = configureDataSource()
    
    
    private let bannerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var productMiniListView = ProductMiniListView()
    
    //MARK: - ViewController Initailizer
    init() {
        super.init(nibName: nil, bundle: nil)
        setupDefaults()
        //updateDataSource(data: ProductListView.sampleData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup ViewController Method
    
    private func setupDefaults() {
        view.backgroundColor = .systemBackground
//        productMiniListView.miniListCollectionView?.delegate = self
        productMiniListView.titleStackView.moreButtonDelegate = self
        productMiniListView.productMiniListCellSelectedDelegate = self
        addUIComponents()
        setupLayout()
        
        guard let request = OpenMarketRequestDirector().createGetRequest(pageNumber: 1, itemsPerPage: 10) else { return }
        NetworkManager().dataTask(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let productList = try JSONDecoder().decode(ProductList.self, from: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.updateDataSource(data: productList.pages)
                    }
                } catch {
                    print("!!")
                }
            case .failure(_):
                print("??")
                DispatchQueue.main.async {
                    //self.showAlert(title: "서버 통신 실패", message: "데이터를 받아오지 못했습니다.")
                }
            }
        }
    }
    
    private func addUIComponents() {
        view.addSubview(bannerView)
        view.addSubview(productMiniListView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bannerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            bannerView.heightAnchor.constraint(equalTo: bannerView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            productMiniListView.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 50),
            productMiniListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productMiniListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productMiniListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
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

//MARK: - More Button AddTargeting delegate

protocol MoreButtonTapDelegate {
    func moreButtonAddGesture()
}

extension MainViewController: MoreButtonTapDelegate {
    func moreButtonAddGesture() {
        navigationController?.pushViewController(ProductListViewController(), animated: true)
    }
}

//MARK: - MiniListViewController Cell select delegate

protocol ProductMiniListCellSelectedDelegate {
    func selectCell(product: Product)
}

extension MainViewController: ProductMiniListCellSelectedDelegate {
    func selectCell(product: Product) {
        //TODO: 여기서 id 로 디테일 가져와서 그걸로 이니셜라이징
        let productDetailViewController = ProductDetailViewController()
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}
