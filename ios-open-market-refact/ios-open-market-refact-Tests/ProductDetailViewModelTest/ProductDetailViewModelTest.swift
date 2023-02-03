//
//  ProductDetailViewModelTest.swift
//  ios-open-market-refact-Tests
//
//  Created by 송기원, 유한석, 이은찬 on 2022/12/20.
//

import XCTest
@testable import ios_open_market_refact

final class ProductDetailViewModelTest: XCTestCase {
    
    struct MockNetworkManager: NetworkManagerProtocol {
        var result: Result<Data, Error>
        func dataTask(with request: APIRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
            completionHandler(result)
        }
    }
 
    func test_유효한_데이터_값이_주어졌을_경우확인() {
        //given
        let viewModel = ProductDetailViewModel(networkAPI: MockNetworkManager(result: .success(StubData(fileName: "ProductDetailStubData").data!)))
        viewModel.productNumber = 1
        
        let productInfo = Observable((ProductDetailViewModel.detailViewRefreshAction.refreshAction))
        let buttonAction = Observable((ProductDetailViewModel.ButtonAction.defaultAction))
        let input = ProductDetailViewModel.Input(fetchProductDetailAction: productInfo, deleteButtonAction: buttonAction, editButtonAction: buttonAction)
        let output = viewModel.transform(input: input)
        
        // when
        let name = output.fetchedProductDetailOutput.value.name
        
        print(output.fetchedProductDetailOutput.value)
        // then
        XCTAssertEqual(name, "StubProductForTest")
    }
    
    func test_유효하지_않는_데이터_값이_주어졌을_경우확인() {
        // given, when
        var result = ""
        let viewModel = ProductDetailViewModel(networkAPI: MockNetworkManager(result: .failure(APIError.invalidData)))
        
        viewModel.productNumber = 1
        viewModel.onErrorHandling = { _ in
            result = "error"
        }
        
        let productInfo = Observable((ProductDetailViewModel.detailViewRefreshAction.refreshAction))
        let buttonAction = Observable((ProductDetailViewModel.ButtonAction.defaultAction))
        let input = ProductDetailViewModel.Input(fetchProductDetailAction: productInfo, deleteButtonAction: buttonAction, editButtonAction: buttonAction)
        
        _ = viewModel.transform(input: input)

        // then
        XCTAssertEqual(result, "error")
    }
    
    func test_버튼이_눌렸을_경우_메서드_실행_확인() {
        // given
        var result = ""
        let viewModel = ProductDetailViewModel(networkAPI: MockNetworkManager(result: .success(StubData(fileName: "ProductDetailStubData").data!)))
        viewModel.productNumber = 1
        
        let productInfo = Observable((ProductDetailViewModel.detailViewRefreshAction.refreshAction))
        let buttonAction = Observable((ProductDetailViewModel.ButtonAction.defaultAction))
        let input = ProductDetailViewModel.Input(fetchProductDetailAction: productInfo, deleteButtonAction: buttonAction, editButtonAction: buttonAction)
        let output = viewModel.transform(input: input)
        
        // when
        
        output.deleteButtonActionOutput.value = .deleteButtonAction
        
        output.deleteButtonActionOutput.subscribe { action in
            result = "buttonTapped"
        }
        
        // then
        
        XCTAssertEqual(result, "buttonTapped")
    }
}
