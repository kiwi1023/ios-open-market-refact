//
//  ProductRegistViewModel.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/12/18.
//

import Foundation

final class ProductRegistViewModel: ViewModelBuilder {
    
    var onErrorHandling : ((APIError) -> Void)?
    
    private let output = Observable(false)
    
    private let networkAPI: SessionProtocol
    private var id = 0
    
    struct Input {
        let postAction: Observable<(RegistrationProduct?, [ProductImage])>
        let patchAction: Observable<(RegistrationProduct?)>
    }
    
    struct Output {
        let doneAction: Observable<(Bool)>
    }
    
    init(networkAPI: SessionProtocol = NetworkManager()) {
        self.networkAPI = networkAPI
    }
    
    func transform(input: Input) -> Output {
        
        input.postAction.subscribe(listener: { [weak self] product, images in
            guard let self = self,
                  let product = product else { return }
            
                self.postProduct(input: product, images: images) { result in
                    switch result {
                    case .success():
                        self.output.value = true
                    case .failure(let failure):
                        self.onErrorHandling?(failure)
                }
            }
        })
        
        input.patchAction.subscribe(listener: { [weak self] product in
            guard let self = self,
                  let product = product else { return }
            
            self.patchProduct(input: product, id: self.id) { result in
                switch result {
                case .success():
                    self.output.value = true
                case .failure(let failure):
                    self.onErrorHandling?(failure)
                }
            }
        })
        
        return .init(doneAction: output)
    }
    
    private func postProduct(
        input: RegistrationProduct,
        images: [ProductImage],
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        
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
    
    private func patchProduct(
        input: RegistrationProduct, id: Int,
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        
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

