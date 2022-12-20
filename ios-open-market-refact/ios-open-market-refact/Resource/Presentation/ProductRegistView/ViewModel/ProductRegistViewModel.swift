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
                self.postProduct(input: product, images: images) {
                    self.output.value = true
                }
            }
        })
        
        input.patchAction.subscribe(listener: { product, update in
            guard let product = product else { return }
            switch update {
            case .unUpdatable:
                return
            case .updatable:
                self.patchProduct(input: product, id: self.id) {
                    self.output.value = true
                }
            }
        })
        
        return .init(doneAction: output)
    }
    
    private func postProduct(input: RegistrationProduct, images: [ProductImage], completion: @escaping () -> Void) {
        guard let request = OpenMarketRequestDirector().createPostRequest(
            product: input,
            images: images
        ) else { return }
        
        networkAPI.dataTask(with: request) { result in
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func patchProduct(input: RegistrationProduct, id: Int, completion: @escaping () -> Void) {
        guard let request = OpenMarketRequestDirector().createPatchRequest(
            product: input,
            productNumber: id
        ) else { return }
        
        networkAPI.dataTask(with: request) { result in
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configure(id: Int) {
        self.id = id
    }
}

