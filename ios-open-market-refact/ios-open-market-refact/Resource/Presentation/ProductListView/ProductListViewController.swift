//
//  ProductListViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
//

import UIKit

final class ProductListViewController: UIViewController {
    
    private let mainView = ProductListView()
    
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
        addUIComponents()
        setupLayout()
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
}
