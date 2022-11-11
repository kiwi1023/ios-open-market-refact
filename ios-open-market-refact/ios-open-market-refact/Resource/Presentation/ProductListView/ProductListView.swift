//
//  ProductListView.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
//

import UIKit

final class ProductListView: UIView {
    
    private var mainCollectionView: UICollectionView?
    private lazy var dataSource: DataSource? = configureDataSource()
    
    enum Section {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Int>
    
    //MARK: - View Initializer
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
        configurationCollectionView()
        updateDataSource(data: [1,2,3,4,5])
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
                                               heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                        repeatingSubitem: item,
                                                        count:1)

        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() -> DataSource? {
        let cellRegistration = UICollectionView.CellRegistration<ProductListViewCell, Int> { cell, indexPath, item in
            
            cell.contentView.backgroundColor = .blue
            if item % 2 == 0 {
                cell.contentView.backgroundColor = .green
            }
        }
        guard let mainCollectionView = mainCollectionView else {
            return nil
        }
        
        return UICollectionViewDiffableDataSource<Section, Int>(collectionView: mainCollectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
    }
    
    private func updateDataSource(data: [Int]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: false, completion: nil)
    }
}

// MARK: - CollectionView delegate

extension ProductListView: UICollectionViewDelegate {
    
}

