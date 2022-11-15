//
//  ProductDetailViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    
    private var product: ProductDetaiil? // TODO: 오타 수정해야함
    
    private lazy var productDetailView = ProductDetailView(productDetail: self.product)
    
    //MARK: - View Initializer
    
    init() {
        self.product = ProductDetailViewController.sampleData
        super.init(nibName: nil, bundle: nil)
        addUIComponents()
        setypLayout()
        setupNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        debugPrint("ProductDetailViewController Initialize Error")
    }
    
    //MARK: - View Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    //MARK: - Setup ViewController method
    
    private func addUIComponents() {
        view.addSubview(productDetailView)
    }
    
    private func setypLayout() {
        NSLayoutConstraint.activate([
            productDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "상품목록"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(didTapDeleteButton)
        )

    }
    
    @objc func didTapDeleteButton() { //TODO: 삭제 로직 추가해야함
        print("didTapSearchingButton!")
    }
}

//MARK: - ProductDetail View Mock Data

extension ProductDetailViewController {
    static let sampleData = ProductDetaiil(
        id: 200,
        vendorID: 11,
        name: "카오스 솔져",
        thumbnail: "https://w.namu.la/s/263874d445e19faa403a3d73ff4612e27defab8cd581ac94af88182389781c568dbd8d81dd1db6d2551001572183184c50127e6bd82b639df56c8a0c94598ae033c51126a511466b9ed7887e7e64ee6ad02eb10827813762d43e5f8aaf76165803152240f22dc3d553004ffe593711e2",
        currency: "KRW", // TODO: Currency 로 변경하기
        price: 15000,
        productDetaiilDescription: "하나의 혼은 빛을 부르고, 하나의 혼은 어둠을 부른다! \n그리고 빛과 어둠의 혼은 카오스를 만들어낸다! \n질주하라, 암흑 기사 가이아! 카오스 필드를 달려나가라! 그리고 초전사의 힘을 얻을지어다!",
        bargainPrice: 13000,
        discountedPrice: 0,
        stock: 1123123,
        createdAt: "2022-02-01",
        issuedAt: "2022-01-31",
        images: [],
        vendors: Vendors(name: "Borysarang", id: 11)
    )
}
