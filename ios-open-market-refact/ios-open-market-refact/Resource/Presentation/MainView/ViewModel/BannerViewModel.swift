//
//  BannerViewModel.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/12/17.
//

import Foundation

class BannerViewModel: ViewModelBuilder {
    
    var networkAPI: SessionProtocol
    var onErrorHandling : ((APIError) -> Void)?
    var bannerImage: Observable<(count: Int, index: Int, imageUrl: String)> = Observable((Int(), Int(), String()))
    
    struct Input {
        let loadBannerImagesAction: Observable<Void>
    }
    
    struct Output {
        let loadBannerImagesOutPut: Observable<(count: Int, index: Int, imageUrl: String)>
    }
    
    init(networkAPI: SessionProtocol = NetworkManager()) {
        self.networkAPI = networkAPI
    }
    
    func transform(input: Input) -> Output {
        input.loadBannerImagesAction.subscribe { [self] action in
            fetchBannerImages { [self] result in
                switch result {
                case .success(let bannerImages):
                    var url: [String] = []
                    bannerImages.forEach {
                        url.append($0.image)
                    }
                    sortImageUrls(imageUrls: url) { index, imageUrl in
                        self.bannerImage.value = (url.count, index, imageUrl)
                    }
                case .failure(let failure):
                    self.onErrorHandling?(failure)
                }
            }
        }
        
        return .init(
            loadBannerImagesOutPut: bannerImage
        )
    }
    
    private func fetchBannerImages(completion: @escaping (Result<[BannerImage],APIError>) -> Void) {
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
                    to: [BannerImage].self)
                else { return }
                
                return completion(.success(bannerImages))
            case .failure(_):
                return completion(.failure(APIError.response))
            }
        }
    }
    
    private func sortImageUrls(imageUrls: [String], completion: @escaping (Int, String) -> Void) {
        for index in 0..<(imageUrls.count + 2) {
            var urlStr = ""
            
            if index == 0 {
                urlStr = imageUrls.last ?? ""
            } else if index == (imageUrls.count + 2) - 1 {
                urlStr = imageUrls.first ?? ""
            } else {
                urlStr = imageUrls[index - 1]
            }
            completion(index, urlStr)
        }
    }
}
