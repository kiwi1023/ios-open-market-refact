//
//  ProductDetailViewModel.swift
//  ios-open-market-refact
//
//  Created by Kiwon Song on 2022/12/18.
//

import Foundation

final class ProductDetailViewModel: ViewModelBuilder {
    
    var productNumber: Int?
    
    var onErrorHandling : ((APIError) -> Void)?
    
    private let networkAPI: SessionProtocol
    
    enum ButtonAction {
        case defaultAction
        case deleteButtonAction
        case editButtonAction
    }
    
    enum detailViewRefreshAction {
        case refreshAction
    }
    
    struct Input {
        let fetchProductDetailAction: Observable<detailViewRefreshAction>
        let deleteButtonAction: Observable<ButtonAction>
        let editButtonAction: Observable<ButtonAction>
    }
    
    struct Output {
        let fetchedProductDetailOutput: Observable<ProductDetail>
        let deleteButtonActionOutput: Observable<ButtonAction>
        let editButtonActionOutput: Observable<(
            productDetail: ProductDetail,
            buttonAction: ButtonAction
        )>
    }
    
    init(networkAPI: SessionProtocol = NetworkManager()) {
        
        self.networkAPI = networkAPI
    }
    
    func transform(input: Input) -> Output {
        
        let fetchedProductDetailOutput = Observable(ProductDetail())
        let deleteButtonOutput = Observable(ButtonAction.defaultAction)
        let editButtonOutput = Observable(
            (productDetail: ProductDetail(), buttonAction: ButtonAction.defaultAction)
        )
        
        input.fetchProductDetailAction.subscribe { [self] action in
            receiveDetailData { result in
                switch result {
                case .success(let productDetail):
                    fetchedProductDetailOutput.value = productDetail
                case .failure(let failure):
                    self.onErrorHandling?(failure)
                }
            }
        }
        
        input.deleteButtonAction.subscribe { [self] action in
            if action == .deleteButtonAction {
                deleteProduct { [self] result in
                    switch result {
                    case .success(_):
                        deleteButtonOutput.value = action
                    case .failure(let failure):
                        self.onErrorHandling?(failure)
                    }
                }
            }
        }
        
        input.editButtonAction.subscribe { action in
            if action == .editButtonAction {
                editButtonOutput.value = (fetchedProductDetailOutput.value, action)
            }
        }
        
        return .init(
            fetchedProductDetailOutput: fetchedProductDetailOutput,
            deleteButtonActionOutput: deleteButtonOutput,
            editButtonActionOutput: editButtonOutput
        )
    }
    
    private func receiveDetailData(completion: @escaping (Result<ProductDetail, APIError>) -> Void) {
        
        guard let productNumber = productNumber,
              let detailRequest = OpenMarketRequestDirector().createGetDetailRequest(
            productNumber
        ) else { return }
        
        self.networkAPI.dataTask(with: detailRequest) { result in
            switch result {
            case .success(let data):
                guard let productDetail = JsonDecoderManager.shared.decode(from: data, to: ProductDetail.self) else { return }
                
                completion(.success(productDetail))
            case .failure(_):
                completion(.failure(APIError.response))
            }
        }
    }
    
    private func deleteProduct(completion: @escaping (Result<Bool, APIError>) -> Void) {
        
        guard let productNumber = productNumber else { return }
        guard let deleteURIRequest = OpenMarketRequestDirector().createDeleteURIRequest(
            productNumber: productNumber
        ) else { return }
        
        
        self.networkAPI.dataTask(with: deleteURIRequest) { result in
            switch result {
            case .success(let data):
                
                guard let deleteRequest = OpenMarketRequestDirector().createDeleteRequest(
                    with: data
                ) else { return }
                
                self.networkAPI.dataTask(with: deleteRequest) { result in
                    switch result {
                    case .success(_):
                        completion(.success(true))
                    case .failure(_):
                        completion(.failure(APIError.response))
                    }
                }
            case .failure(_):
                completion(.failure(APIError.response))
            }
        }
    }
}
