//
//  MainViewModelTest.swift
//  ios-open-market-refact-Tests
//
//  Created by 이은찬 on 2022/12/17.
//

import XCTest
@testable import ios_open_market_refact

final class MainViewModelTest: XCTestCase {
    
    struct MockSession: SessionProtocol {
        var result: Result<Data, Error>
        func dataTask(with request: ios_open_market_refact.APIRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
            completionHandler(result)
        }
    }
    
    func test_유효한_데이터_값이_주어졌을_경우확인() {
        // given
        let viewModel = MainViewModel(networkAPI: MockSession(result: .success(MockData(fileName: "ProductListMockData").data!)))
        let updateAction = Observable((pageNumber: 1, itemsPerPage: 5))
        let input = MainViewModel.Input(pageInfoInput: updateAction)
        let output = viewModel.transform(input: input)

        // when
        let name = output.fetchedProductListOutput.value.first?.name
        
        // then
        XCTAssertEqual(name, "MockProductForTest")
    }
    
    func test_유효하지_않는_데이터_값이_주어졌을_경우확인() {
        // given, when
        var result = ""
        let viewModel = MainViewModel(networkAPI: MockSession(result: .failure(APIError.invalidData)))
        
        viewModel.onErrorHandling = { _ in
            result = "error"
        }
        
        let updateAction = Observable((pageNumber: 1, itemsPerPage: 5))
        let input = MainViewModel.Input(pageInfoInput: updateAction)
        _ = viewModel.transform(input: input)
        
        // then
        XCTAssertEqual(result, "error")
    }
    
    func test_값을_변경했을때_subscribe발동확인() {
        // given
        var result = ""
        let viewModel = MainViewModel(networkAPI: MockSession(result: .success(MockData(fileName: "ProductListMockData").data!)))
        let updateAction = Observable((pageNumber: 1, itemsPerPage: 5))
        let input = MainViewModel.Input(pageInfoInput: updateAction)
        let output = viewModel.transform(input: input)
        
        output.fetchedProductListOutput.subscribe { products in
            result = products.first!.name
        }
        
        // when
        output.fetchedProductListOutput.value = [Product(id: 1, vendorID: 1, name: "test", description: "test", thumbnail: "test", currency: .krw, price: 0.0, bargainPrice: 0.0, discountedPrice: 0.0, stock: 0, createdAt: "", issuedAt: "")]
        
        // then
        XCTAssertEqual(result, "test")
    }
}
