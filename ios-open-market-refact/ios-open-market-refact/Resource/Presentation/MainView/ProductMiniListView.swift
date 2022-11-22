//
//  ProductMiniListView.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/11/16.
//

import UIKit

final class ProductMiniListView: SuperViewSetting {
    
    var productMiniListCellSelectedDelegate: ProductMiniListCellSelectedDelegate?
    
    var titleStackView = ProductMiniListTitleStackView()
    private(set) var miniListCollectionView: UICollectionView?
    
    //MARK: - Setup ProductMiniListView Method
    
    override func setupDefault() {
        translatesAutoresizingMaskIntoConstraints = false
        addUIComponents()
        setupLayout()
        configureCollectionView()
    }
    
    override func addUIComponents() {
        addSubview(titleStackView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    private func configureCollectionView() {
        miniListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createHorizonalCollectionViewLayout())
        guard let miniListCollectionView = miniListCollectionView else {
            return
        }
        miniListCollectionView.delegate = self 
        addSubview(miniListCollectionView)
        miniListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        miniListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            miniListCollectionView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 20),
            miniListCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            miniListCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            miniListCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
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
//MARK: - CollectionView delegate

extension ProductMiniListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductMiniListViewCell,
              let product = cell.product
        else {
            return
        }
        productMiniListCellSelectedDelegate?.selectCell(product: product)
    }
}
