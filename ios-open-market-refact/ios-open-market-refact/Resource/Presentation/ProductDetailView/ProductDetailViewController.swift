//
//  ProductDetailViewController.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/14.
//

import UIKit

private enum ProductDetailViewControllerNameSpace {
    static let deleteCompletionMessage = "해당 상품을 삭제 완료했습니다."
    static let deleteFailureMessage = "제품을 삭제하지 못했습니다."
    static let wrongPasswordMessage = "비밀번호가 틀렸습니다"
    static let dataLoadFailureMessage = "데이터를 불러오지 못했습니다."
}

final class ProductDetailViewController: SuperViewControllerSetting {
    
    private var productDetail: ProductDetail?
    private var productNumber: Int?
    private lazy var productDetailView = ProductDetailView()
    
    //MARK: - Setup ViewController method
    
    override func setupDefault() {
        super.setupDefault()
        receiveDetailData()
        productDetailView.changeCurrentPage = { [self] in
            receiveDetailData()
        }
    }
    
    override func addUIComponents() {
        super.addUIComponents()
        view.addSubview(productDetailView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        NSLayoutConstraint.activate([
            productDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar(productDetail: ProductDetail) {
        if productDetail.vendorID == UserInfo.id {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .action,
                target: self,
                action: #selector(didTapEitButton)
            )
        }
        
        navigationItem.title = productDetail.name
    }
    
    @objc private func didTapEitButton() {
        AlertDirector(viewController: self).createProductEditActionSheet { [weak self] _ in
            self?.convertToEditView()
        } deleteAction: { [weak self] _ in
            self?.didTapDeleteButton()
        }
    }
    
    private func convertToEditView() {
        guard let productDetail = productDetail else { return }
        
        let registView = ProductRegistViewController(product: productDetail)
        
        registView.refreshList = {
            self.receiveDetailData()
        }
        
        navigationController?.pushViewController(registView, animated: true)
    }
    
    private func didTapDeleteButton() {
        AlertDirector(viewController: self).createProductDeleteAlert { [weak self] _ in
            self?.deleteProduct()
            self?.removeCurrentProduct()
        }
    }
    
    private func removeCurrentProduct() {
        AlertDirector(viewController: self).createProductDeleteSuccessAlert(
            message: ProductDetailViewControllerNameSpace.deleteCompletionMessage
        ) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func receiveProductNumber(productNumber: Int) {
        self.productNumber = productNumber
    }
    
    private func deleteProduct() {
        guard let productNumber = productNumber else { return }
        guard let deleteURIRequest = OpenMarketRequestDirector().createDeleteURIRequest(
            productNumber: productNumber
        ) else { return }
        
        
        NetworkManager().dataTask(with: deleteURIRequest) { result in
            switch result {
            case .success(let data):
                
                guard let deleteRequest = OpenMarketRequestDirector().createDeleteRequest(
                    with: data
                ) else { return }
                
                NetworkManager().dataTask(with: deleteRequest) { result in
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .productDataDidChanged,
                                                            object: self)
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(_):
                        AlertDirector(viewController: self).createErrorAlert(
                            message:ProductDetailViewControllerNameSpace.deleteFailureMessage
                        )
                    }
                }
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(
                    message: ProductDetailViewControllerNameSpace.wrongPasswordMessage
                )
            }
        }
    }
    
    private func receiveDetailData() {
        guard let productNumber = productNumber else { return }
        guard let detailRequest = OpenMarketRequestDirector().createGetDetailRequest(
            productNumber
        ) else { return }
        
        NetworkManager().dataTask(with: detailRequest) { [self] result in
            switch result {
            case .success(let data):
                productDetail = JsonDecoderManager.shared.decode(from: data, to: ProductDetail.self)
                
                guard let productDetail = productDetail else { return }
                
                DispatchQueue.main.async { [self] in
                    configureNavigationBar(productDetail: productDetail)
                    productDetailView.getProductDetailData(productDetail: productDetail)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    AlertDirector(viewController: self).createErrorAlert(
                        message: ProductDetailViewControllerNameSpace.dataLoadFailureMessage
                    )
                }
            }
        }
    }
}
