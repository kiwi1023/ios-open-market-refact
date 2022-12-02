//
//  ProductListView.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
//

import UIKit

final class ProductListView: SuperViewSetting {
    
    private(set) var mainCollectionView: UICollectionView?
    
    //MARK: - View Initializer
    
    required init() {
        super.init()
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
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
                                               heightDimension: .fractionalWidth(1/4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count:1)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
