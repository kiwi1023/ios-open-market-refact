//
//  BannerViewModel.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/12/17.
//

import Foundation

class BannerViewModel: ViewModelBuilder {
    
    private let networkAPI: SessionProtocol
    var onErrorHandling : ((APIError) -> Void)?
    
    struct Input {
        let loadBannerImagesAction: Observable<Void>
    }
    
    struct Output {
        let loadBannerImagesOutPut: Observable<[String]>
    }
    
    init(networkAPI: SessionProtocol = NetworkManager()) {
        self.networkAPI = networkAPI
    }
    
    func transform(input: Input) -> Output {
        let bannerImageOutput = Observable([""])
        
        input.loadBannerImagesAction.subscribe { [self] action in
            fetchBannerImages { [self] result in
                switch result {
                case .success(let bannerImages):
                    var url: [String] = []
                    bannerImages.forEach {
                        url.append($0.image)
                    }
                    bannerImageOutput.value = sortImageUrls(imageUrls: url)
                    
                case .failure(let failure):
                    self.onErrorHandling?(failure)
                }
            }
        }
        
        return .init(
            loadBannerImagesOutPut: bannerImageOutput
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
    
    private func sortImageUrls(imageUrls: [String]) -> [String] {
        var result: [String] = []
        
        for index in 0..<(imageUrls.count + 2) {
            var urlStr = ""
            
            if index == 0 {
                urlStr = imageUrls.last ?? ""
            } else if index == (imageUrls.count + 2) - 1 {
                urlStr = imageUrls.first ?? ""
            } else {
                urlStr = imageUrls[index - 1]
            }
            result.append(urlStr)
        }
        return result
    }
}
