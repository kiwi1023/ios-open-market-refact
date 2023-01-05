//
//  ProductListViewModel.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/12/17.
//

import Foundation

final class ProductListViewModel: ViewModelBuilder {
    
    private let networkAPI: NetworkManagerProtocol
    var onErrorHandling : ((APIError) -> Void)?
    
    private var productList: [Product] = []
    private var selectedIndexPath: IndexPath?
    private var appendingProuctList: [Product] = []
    
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
    
    init(networkAPI: NetworkManagerProtocol = NetworkManager()) {
        self.networkAPI = networkAPI
    }
    
    func transform(input: Input) -> Output {
        let fetchedProductList = Observable<[Product]>([])
        let fileteredProductList = Observable<[Product]>([])
        
        input.productListPageInfoUpdateAction.subscribe { [self] (
            pageNumber: Int,
            itemsPerPage: Int,
            fetchType: ProductListViewController.FetchType
        ) in
            self.fetchedCurrentProductList(
                pageNumber: pageNumber,
                itemsPerPage: itemsPerPage,
                fetchType: fetchType
            ) { [weak self] (result: Result<Bool, APIError>) in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    switch input.productListPageInfoUpdateAction.value.fetchType {
                    case .update:
                        fetchedProductList.value = self.productList
                    case .add:
                        fetchedProductList.value = self.appendingProuctList
                    }
                    
                case .failure(let failure):
                    self.onErrorHandling?(failure)
                }
            }
        }
        
        input.filteringStateUpdateAction.subscribe { [weak self] filteringWord in
            guard let self = self else { return }
            
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
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                guard let fetchedList = JsonDecoderManager.shared.decode(
                    from: data,
                    to: ProductList.self
                ) else { return }
                switch fetchType {
                case .update:
                    self.productList = fetchedList.pages
                case .add:
                    self.productList += fetchedList.pages
                    self.appendingProuctList = fetchedList.pages
                }
                completion(.success(true))
            case .failure:
                completion(.failure(APIError.response))
            }
        }
    }
}
