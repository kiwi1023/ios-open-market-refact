//
//  ProductMiniListView.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/16.
//

import UIKit

final class ProductMiniListView: SuperViewSetting {
    
    var titleStackView = ProductMiniListTitleStackView()
    private(set) lazy var miniListCollectionView = UICollectionView(frame: .zero,
                                                                                 collectionViewLayout: createHorizonalCollectionViewLayout())
    
    //MARK: - Setup ProductMiniListView Method
    
    override func setupDefault() {
        super.setupDefault()
        miniListCollectionView.isScrollEnabled = false
    }
    
    override func addUIComponents() {
        super.addUIComponents()
        addSubview(miniListCollectionView)
        addSubview(titleStackView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        miniListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        miniListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            miniListCollectionView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 10),
            miniListCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            miniListCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            miniListCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            titleStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    private func createHorizonalCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                               heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
