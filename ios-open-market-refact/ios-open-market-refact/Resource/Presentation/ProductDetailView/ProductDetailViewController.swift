//
//  ProductDetailViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

final class ProductDetailViewController: SuperViewControllerSetting {
    
    private var productDetail: ProductDetail?
    private var productNumber: Int?
    private lazy var productDetailView = ProductDetailView()
    
    //MARK: - Setup ViewController method
    
    override func setupDefault() {
        receiveDetailData()
    }
    
    override func addUIComponents() {
        view.addSubview(productDetailView)
    }
    
    override func setupLayout() {
        NSLayoutConstraint.activate([
            productDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar(productDetail: ProductDetail) {
        if productDetail.vendorID == UserInfo.id {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(editButtonDidTapped))
        }
        navigationItem.title = productDetail.name
    }
    
    @objc private func editButtonDidTapped() {
        AlertDirector(viewController: self).createProductEditActionSheet { [weak self] _ in
            self?.convertToEditView()
        } deleteAction: { [weak self] _ in
            self?.didTapDeleteButton()
        }
    }
    
    
    private func convertToEditView() {
        guard let productDetail = self.productDetail else { return }
        let registView = ProductRegistViewController(product: productDetail)
        registView.refreshList = {
            self.receiveDetailData()
        }
        navigationController?.pushViewController(registView, animated: true)
    }
    
    func didTapDeleteButton() {
        AlertDirector(viewController: self).createProductDeleteAlert { [weak self] _ in
            self?.deleteProduct()
            self?.removeCurrentProduct()
        }
    }
    
    private func removeCurrentProduct() {
        AlertDirector(viewController: self).createProductDeleteSuccessAlert(message: "해당 상품을 삭제 완료했습니다.")
    }
    
    func receiveProductNumber(productNumber: Int) {
        self.productNumber = productNumber
    }
    
    private func deleteProduct() {
        guard let productNumber = productNumber else { return }
        guard let deleteURIRequest = OpenMarketRequestDirector().createDeleteURIRequest(productNumber: productNumber) else { return }
        
        
        NetworkManager().dataTask(with: deleteURIRequest) { result in
            switch result {
            case .success(let data):
                
                guard let deleteRequest = OpenMarketRequestDirector().createDeleteRequest(with: data) else { return }
                
                NetworkManager().dataTask(with: deleteRequest) { result in
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(_):
                        AlertDirector(viewController: self).createErrorAlert(message: "제품을 삭제하지 못했습니다.")
                    }
                }
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "비밀번호가 틀렸습니다")
            }
        }
    }
}
//MARK: - ProductDetail View Mock Data

extension ProductDetailViewController {
    private func receiveDetailData() {
        guard let productNumber = productNumber else { return }
        guard let detailRequest = OpenMarketRequestDirector().createGetDetailRequest(productNumber) else { return }
        
        NetworkManager().dataTask(with: detailRequest) { [self] result in
            switch result {
            case .success(let data):
                productDetail = JSONDecoder.decodeJson(jsonData: data)
                
                guard let productDetail = productDetail else { return }
                
                DispatchQueue.main.async { [self] in
                    configureNavigationBar(productDetail: productDetail)
                    productDetailView.getProductDetailData(productDetail: productDetail)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    AlertDirector(viewController: self).createErrorAlert(message: "데이터를 불러오지 못했습니다.")
                }
            }
        }
    }
}
