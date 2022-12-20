//
//  ProductRegistViewModel.swift
//  ios-open-market-refact
//
//  Created by 이은찬 on 2022/12/18.
//

import Foundation

enum Update {
    case updatable
    case unUpdatable
}

final class ProductRegistViewModel: ViewModelBuilder {
    var onErrorHandling : ((APIError) -> Void)?
    
    private let output = Observable(false)
    
    let networkAPI: SessionProtocol
    private var id = 0
    
    struct Input {
        let postAction: Observable<(RegistrationProduct?, [ProductImage], Update)>
        let patchAction: Observable<(RegistrationProduct?, Update)>
    }
    
    struct Output {
        let doneAction: Observable<(Bool)>
    }
    
    init(networkAPI: SessionProtocol) {
        self.networkAPI = networkAPI
    }
    
    func transform(input: Input) -> Output {
        input.postAction.subscribe(listener: { product, images, update in
            guard let product = product else { return }
            switch update {
            case .unUpdatable:
                return
            case .updatable:
                self.postProduct(input: product, images: images) { result in
                    switch result {
                    case .success():
                        self.output.value = true
                    case .failure(let failure):
                        self.onErrorHandling?(failure)
                    }
                }
            }
        })
        
        input.patchAction.subscribe(listener: { product, update in
            guard let product = product else { return }
            switch update {
            case .unUpdatable:
                return
            case .updatable:
                self.patchProduct(input: product, id: self.id) { result in
                    switch result {
                    case .success():
                        self.output.value = true
                    case .failure(let failure):
                        self.onErrorHandling?(failure)
                    }
                }
            }
        })
        
        return .init(doneAction: output)
    }
    
    private func postProduct(input: RegistrationProduct, images: [ProductImage], completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let request = OpenMarketRequestDirector().createPostRequest(
            product: input,
            images: images
        ) else { return }
        
        self.networkAPI.dataTask(with: request) { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure:
                completion(.failure(APIError.response))
            }
        }
    }
    
    private func patchProduct(input: RegistrationProduct, id: Int, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let request = OpenMarketRequestDirector().createPatchRequest(
            product: input,
            productNumber: id
        ) else { return }
        
        self.networkAPI.dataTask(with: request) { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure:
                completion(.failure(APIError.response))
            }
        }
    }
    
    func configure(id: Int) {
        self.id = id
    }
}
