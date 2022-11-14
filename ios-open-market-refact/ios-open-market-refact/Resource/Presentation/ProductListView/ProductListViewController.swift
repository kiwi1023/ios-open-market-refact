//
//  ProductListViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
//

import UIKit

final class ProductListViewController: UIViewController {
    
    private lazy var mainView = ProductListView()
    
    //MARK: - ViewController Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupDefault()
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
}

//MARK: - SearchBar Controller

extension ProductListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        if text == "" {
            mainView.updateDataSource(data: ProductListView.sampleData)
        } else {
            mainView.updateDataSource(data: ProductListView.sampleData.filter({ product in
                product.name.lowercased().contains(text)
            }))
        }
    }
}
