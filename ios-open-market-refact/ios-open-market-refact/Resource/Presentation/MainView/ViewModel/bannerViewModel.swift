//
//  bannerViewModel.swift
//  ios-open-market-refact
//
//  Created by Kiwon Song on 2022/12/15.
//

import Foundation

class BannerViewModel: ViewModelBuilderProtocol {
    
    var bannerImage: Observable<(index: Int, imageUrl: String)> = Observable((Int(), String()))
    var networkAPI: SessionProtocol
    
    struct Input {
        let setBannerImagesAction: Observable<(imageViewsCount: Int, imageUrls: [String])>
    }
    
    struct Output {
        let bannerImageOutPut: Observable<(index: Int, imageUrl: String)>
    }
    
    required init(networkAPI: SessionProtocol = NetworkManager()) {
        self.networkAPI = networkAPI
    }
    
    func transform(input: Input) -> Output {
        input.setBannerImagesAction.subscribe { [self] (imageViewsCount: Int, imageUrls: [String]) in
            downloadImages(input: input.setBannerImagesAction) { [self] index, imageUrl in
                bannerImage.value = (index, imageUrl)
            }
        }
        
        return .init(
           bannerImageOutPut: bannerImage
        )
    }
    
    private func downloadImages(input: Observable<(imageViewsCount: Int, imageUrls: [String])>, completion: @escaping (Int, String) -> Void) {
        for index in 0..<input.value.imageViewsCount {
            var urlStr = ""
        
            if index == 0 {
                urlStr = input.value.imageUrls.last ?? ""
            } else if index == input.value.imageViewsCount - 1 {
                urlStr = input.value.imageUrls.first ?? ""
            } else {
                urlStr = input.value.imageUrls[index - 1]
            }
        
            completion(index, urlStr)
        }
    }
}
