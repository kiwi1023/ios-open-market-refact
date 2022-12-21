//
//  MainViewModelTest.swift
//  ios-open-market-refact-Tests
//
//  Created by 송기원, 유한석, 이은찬 on 2022/12/17.
//

import XCTest
@testable import ios_open_market_refact

final class BannerViewModelTest: XCTestCase {
    
    struct MockSession: SessionProtocol {
        var result: Result<Data, Error>
        func dataTask(with request: APIRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
            completionHandler(result)
        }
    }
    
    func test_유효한_데이터_값이_주어졌을_경우확인() {
        // given
        let viewModel = BannerViewModel(
            networkAPI: MockSession(result: .success(MockData(fileName: "BannerImageUrlMockData").data!))
        )
        let bannerImageUrlLoadAction = Observable<Void>(())
        let input = BannerViewModel.Input(loadBannerImagesAction: bannerImageUrlLoadAction)
        let output = viewModel.transform(input: input)

        // when
        let imageUrlCounts = output.loadBannerImagesOutPut.value.count
        
        // then
        XCTAssertEqual(imageUrlCounts, 6)
    }
    
    func test_유효하지_않는_데이터_값이_주어졌을_경우확인() {
        // given, when
        var result = ""
        let viewModel = BannerViewModel(networkAPI: MockSession(result: .failure(APIError.invalidData)))
        
        viewModel.onErrorHandling = { _ in
            result = "error"
        }
        
        let bannerImageUrlLoadAction = Observable<Void>(())
        let input = BannerViewModel.Input(loadBannerImagesAction: bannerImageUrlLoadAction)
        _ = viewModel.transform(input: input)
        
        // then
        XCTAssertEqual(result, "error")
    }
}
