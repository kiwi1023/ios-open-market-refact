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
    
    private let productDetailViewModel = ProductDetailViewModel()
    private let productDetailView = ProductDetailView()
    
    private let fetchProductDetailAction = Observable(ProductDetailViewModel.detailViewRefreshAction.refreshAction)
    private var deleteButtonAction = Observable(ProductDetailViewModel.ButtonAction.defaultAction)
    private var editButtonAction = Observable(ProductDetailViewModel.ButtonAction.defaultAction)
    
    //MARK: - Setup ViewController method
    
    override func setupDefault() {
        super.setupDefault()
        bind()
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
            self?.editButtonAction.value = .editButtonAction
        } deleteAction: { [weak self] _ in
            self?.didTapDeleteButton()
        }
    }
    
    private func convertToEditView(productDetail: ProductDetail) {
        
        let registView = ProductRegistViewController()
        registView.configureProduct(product: productDetail)
        
        registView.refreshList = {
            self.fetchProductDetailAction.value = ProductDetailViewModel.detailViewRefreshAction.refreshAction
        }
        
        navigationController?.pushViewController(registView, animated: true)
    }
    
    private func didTapDeleteButton() {
        deleteButtonAction.value = .deleteButtonAction
    }
    
    private func removeCurrentProduct() {
        AlertDirector(viewController: self).createProductDeleteSuccessAlert(
            message: ProductDetailViewControllerNameSpace.deleteCompletionMessage
        ) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func receiveProductNumber(productNumber: Int) {
        self.productDetailViewModel.productNumber = productNumber
    }
    
    private func bind() {
        
        productDetailView.changeCurrentPage = {
            self.fetchProductDetailAction.value = ProductDetailViewModel.detailViewRefreshAction.refreshAction
        }
        
        let input = ProductDetailViewModel.Input(fetchProductDetailAction: fetchProductDetailAction, deleteButtonAction: deleteButtonAction, editButtonAction: editButtonAction)
        
        let output = productDetailViewModel.transform(input: input)
        
        output.fetchedProductDetailOutput.subscribe { [self] productDetail in
            DispatchQueue.main.async { [self] in
                configureNavigationBar(productDetail: productDetail)
                productDetailView.getProductDetailData(productDetail: productDetail)
            }
        }
        
        output.deleteButtonActionOutput.subscribe { [self] action in
            guard action == .deleteButtonAction else  { return }
            
            DispatchQueue.main.async { [self] in
                AlertDirector(viewController: self).createProductDeleteAlert { [weak self] _ in
                    self?.removeCurrentProduct()
                    NotificationCenter.default.post(name: .addProductData,
                                                    object: self)
                }
            }
        }
        
        
        output.editButtonActionOutput.subscribe { [self] productDetail, action in
            guard action == .editButtonAction else  { return }
            
            DispatchQueue.main.async { [self] in
                convertToEditView(productDetail: productDetail)
            }
        }
        
        productDetailViewModel.onErrorHandling = { failure in
            AlertDirector(viewController: self).createErrorAlert(
                message: ProductDetailViewControllerNameSpace.dataLoadFailureMessage
            )
        }
    }
}


