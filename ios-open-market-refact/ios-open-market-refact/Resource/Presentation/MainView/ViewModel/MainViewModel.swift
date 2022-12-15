//
//  MainViewModel.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/12/07.
//

import Foundation

class MainViewModel: ViewModelBuilderProtocol {
    
    var productList: Observable<[Product]> = Observable([])
    let networkAPI: SessionProtocol
    
    enum MainViewAction {
        case bannerImageLoad
    }
    
    struct Input {
        let productMiniListFetchAction: Observable<(pageNumber: Int, itemsPerPage: Int)>
        let bannerImageLoadAction: Observable<MainViewAction>
    }
    
    
    struct Output {
        let productListOutput : Observable<[Product]>
        let bannerImagesOutput: Observable<[String]>
    }
        
    required init(networkAPI: SessionProtocol = NetworkManager()) {
        self.networkAPI = networkAPI
    }
    
    func transform(input: Input) -> Output {
        let bannerImagesOutput = Observable<[String]>([])
        
        input.productMiniListFetchAction.subscribe { [self] (pageNumber: Int, itemsPerPage: Int) in
            fetchProductList(input: input.productMiniListFetchAction) { [self] fetchedList in
                productList.value = fetchedList.pages
            }
        }
        
        input.bannerImageLoadAction.subscribe { [self] action in
            fetchBannerImages { bannerImages in
                var url: [String] = []
                bannerImages.forEach {
                    url.append($0.image)
                }
                bannerImagesOutput.value = url
            }
        }
        
        return .init(
            productListOutput: productList,
            bannerImagesOutput: bannerImagesOutput
        )
    }
    
    private func fetchProductList(input: Observable<(pageNumber: Int, itemsPerPage: Int)>, completion: @escaping (ProductList) -> Void) {
        guard let request = OpenMarketRequestDirector().createGetRequest(
            pageNumber: input.value.pageNumber,
            itemsPerPage: input.value.itemsPerPage
        ) else {
            return
        }

        self.networkAPI.dataTask(with: request) { result in
            switch result {
            case .success(let data):
                guard let productList = JsonDecoderManager.shared.decode(
                    from: data,
                    to: ProductList.self
                ) else { return }
                completion(productList)
            case .failure(_):
                debugPrint("이잉!")
            }
        }
    }
    
    private func fetchBannerImages(completion: @escaping ([BannerImage]) -> Void) {
        let request = OpenMarketRequest(
            method: .get,
            baseURL: URLHost.mainBannerImages.url,
            path: .bannerImages
        )
        self.networkAPI.dataTask(with: request) { result in
            switch result {
            case .success(let data):
                guard let bannerImages = JsonDecoderManager.shared.decode(
                    from: data,
                    to: [BannerImage].self
                ) else { return }
                completion(bannerImages)
            case .failure(_):
                debugPrint("에엥!")
            }
        }
    }
}
