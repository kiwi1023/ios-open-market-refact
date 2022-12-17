//
//  ProductListViewModel.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/12/15.
//

import Foundation

final class ProductListViewModel: ViewModelBuilderProtocol {
    
    var onErrorHandling : ((APIError) -> Void)?
    
    private var productList: [Product] = []
    private var selectedIndexPath: IndexPath?
    
    let networkAPI: SessionProtocol
    
    struct Input {
        let productListPageInfoUpdateAction: Observable<(
            pageNumber: Int,
            itemsPerPage: Int,
            fetchType: ProductListViewController.FetchType
        )>
        let filteringStateUpdateAction: Observable<String>
    }
    
    
    struct Output {
        let productListOutput : Observable<[Product]>
        let filteredListOutput: Observable<[Product]>
    }
    
    init(networkAPI: SessionProtocol = NetworkManager()) {
        self.networkAPI = networkAPI
    }
    
    func transform(input: Input) -> Output {
        let fetchedProductList = Observable<[Product]>([])
        let fileteredProductList = Observable<[Product]>([])
        
        input.productListPageInfoUpdateAction.subscribe { (pageNumber: Int, itemsPerPage: Int, fetchType: ProductListViewController.FetchType) in
            self.fetchedCurrentProductList(pageNumber: pageNumber, itemsPerPage: itemsPerPage, fetchType: fetchType) { (result: Result<Bool, APIError>) in
                switch result {
                case .success:
                    fetchedProductList.value = self.productList
                case .failure(let failure):
                    self.onErrorHandling?(failure)
                }
            }
        }
        
        input.filteringStateUpdateAction.subscribe { filteringWord in
            fileteredProductList.value = self.productList.filter({ product in
                product.name.lowercased().contains(filteringWord)
            })
        }
        
        return .init(
            productListOutput: fetchedProductList,
            filteredListOutput: fileteredProductList
        )
    }
    
    private func fetchedCurrentProductList(
        pageNumber: Int,
        itemsPerPage: Int,
        fetchType: ProductListViewController.FetchType,
        completion: @escaping (Result<Bool, APIError>) -> Void
    ) {
        guard let productListGetRequest = OpenMarketRequestDirector()
            .createGetRequest(
                pageNumber: pageNumber,
                itemsPerPage: itemsPerPage
            ) else { return }
        
        self.networkAPI.dataTask(with: productListGetRequest) { [weak self] result in
            switch result {
            case .success(let data):
                guard let fetchedList = JsonDecoderManager.shared.decode(
                    from: data,
                    to: ProductList.self
                ) else { return }
                switch fetchType {
                case .update:
                    self?.productList = fetchedList.pages
                case .add:
                    self?.productList += fetchedList.pages
                }
                completion(.success(true))
            case .failure:
                completion(.failure(APIError.response))
            }
        }
    }
}
