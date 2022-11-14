//
//  ProductListView.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
//

import UIKit

final class ProductListView: UIView {

    private(set) var mainCollectionView: UICollectionView?
    
    
    //MARK: - View Initializer
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        configurationCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        debugPrint("ProductListViewController Initialize error")
    }
    
    //MARK: - Setup Collection View Method
    
    private func configurationCollectionView() {
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
        
        guard let mainCollectionView = mainCollectionView else {
            return
        }
        addSubview(mainCollectionView)
        mainCollectionView.delegate = self
        mainCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            mainCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                        repeatingSubitem: item,
                                                        count:1)

        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - CollectionView delegate

extension ProductListView: UICollectionViewDelegate {
    
}

// MARK: - Mock Data

extension ProductListView {
    static var filteredData: [Product] = []
    
    static var sampleData = [
        Product(id: 186, vendorID: 11, name: "블랙매지션", description: "마라탕", thumbnail: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/11/20221110/aa84877e610b11eda917ed59733c203d_thumb.jpeg", currency: .krw, price: 15000.0, bargainPrice: 1000.0, discountedPrice: 0.0, stock: 11, createdAt: "2022-11-10T00:00:00", issuedAt: "2022-11-10T00:00:00"),
        Product(id: 187, vendorID: 11, name: "블랙매지션1", description: "마라탕", thumbnail: "", currency: .krw, price: 15000.0, bargainPrice: 15000.0, discountedPrice: 0.0, stock: 11, createdAt: "2022-11-10T00:00:00", issuedAt: "2022-11-10T00:00:00"),
        Product(id: 188, vendorID: 11, name: "블랙매지션2", description: "마라탕", thumbnail: "", currency: .krw, price: 15000.0, bargainPrice: 15000.0, discountedPrice: 0.0, stock: 11, createdAt: "2022-11-10T00:00:00", issuedAt: "2022-11-10T00:00:00"),
        Product(id: 189, vendorID: 11, name: "푸른눈의백룡1", description: "마라탕", thumbnail: "", currency: .krw, price: 15000.0, bargainPrice: 15000.0, discountedPrice: 0.0, stock: 11, createdAt: "2022-11-10T00:00:00", issuedAt: "2022-11-10T00:00:00"),
        Product(id: 190, vendorID: 11, name: "푸른눈의백룡2", description: "마라탕", thumbnail: "", currency: .krw, price: 15000.0, bargainPrice: 15000.0, discountedPrice: 0.0, stock: 11, createdAt: "2022-11-10T00:00:00", issuedAt: "2022-11-10T00:00:00"),
        Product(id: 191, vendorID: 11, name: "푸른눈의백룡3", description: "마라탕", thumbnail: "", currency: .krw, price: 15000.0, bargainPrice: 15000.0, discountedPrice: 0.0, stock: 11, createdAt: "2022-11-10T00:00:00", issuedAt: "2022-11-10T00:00:00"),
        Product(id: 192, vendorID: 11, name: "푸른눈의백룡4", description: "마라탕", thumbnail: "", currency: .krw, price: 15000.0, bargainPrice: 15000.0, discountedPrice: 0.0, stock: 11, createdAt: "2022-11-10T00:00:00", issuedAt: "2022-11-10T00:00:00")
    ]
}
