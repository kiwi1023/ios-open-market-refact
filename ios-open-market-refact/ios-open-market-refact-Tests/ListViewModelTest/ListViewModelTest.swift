//
//  ListViewModelTest.swift
//  ios-open-market-refact-Tests
//
//  Created by 이은찬 on 2022/12/18.
//

import XCTest
@testable import ios_open_market_refact

final class ListViewModelTest: XCTestCase {
    
    struct MockSession: SessionProtocol {
        var result: Result<Data, Error>
        func dataTask(with request: APIRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
            completionHandler(result)
        }
    }
    
    func test_item_갯수확인() {
        var count = 0
        let viewModel = ProductListViewModel(networkAPI: MockSession(result: .success(MockData(fileName: "ProductListMockData").data!)))
        let pageInfo = Observable((pageNumber: 1, itemsPerPage: 5,
                                   fetchType: ProductListViewController.FetchType.add))
        let filteringState = Observable("")
        let input = ProductListViewModel.Input(productListPageInfoUpdateAction: pageInfo,
                                               filteringStateUpdateAction: filteringState
                                               )
        let output = viewModel.transform(input: input)
        
        
        output.productListOutput.subscribe { products in
            count = products.count
        }
        
        XCTAssertEqual(count, 5)
    }
    
    func test_유효한_데이터_값이_주어졌을_경우확인() {
        // given
        let viewModel = ProductListViewModel(networkAPI: MockSession(result: .success(MockData(fileName: "ProductListMockData").data!)))
        let pageInfo = Observable((pageNumber: 1, itemsPerPage: 5, fetchType: ProductListViewController.FetchType.add))
        let filteringState = Observable("mock")
        let input = ProductListViewModel.Input(productListPageInfoUpdateAction: pageInfo,
                                               filteringStateUpdateAction: filteringState
                                               )
        let output = viewModel.transform(input: input)

        // when
        let name = output.productListOutput.value.first?.name
        let lowercasedName = output.filteredListOutput.value.first?.name
        
        // then
        XCTAssertEqual(name, "MockProductForTest")
        XCTAssertEqual(lowercasedName, "MockProductForTest")
    }
    
    func test_유효하지_않는_데이터_값이_주어졌을_경우확인() {
        // given, when
        var result = ""
        let viewModel = ProductListViewModel(networkAPI: MockSession(result: .failure(APIError.invalidData)))

        viewModel.onErrorHandling = { _ in
            result = "error"
        }

        let pageInfo = Observable((pageNumber: 1, itemsPerPage: 5,
                                   fetchType: ProductListViewController.FetchType.add))
        let filteringState = Observable("")
        let input = ProductListViewModel.Input(productListPageInfoUpdateAction: pageInfo,
                                               filteringStateUpdateAction: filteringState
                                               )

        _ = viewModel.transform(input: input)

        // then
        XCTAssertEqual(result, "error")
    }
    
    func test_값을_변경했을때_subscribe발동확인() {
        // given
        var result = ""
        let viewModel = ProductListViewModel(networkAPI: MockSession(result: .success(MockData(fileName: "ProductListMockData").data!)))
        let pageInfo = Observable((pageNumber: 1, itemsPerPage: 5,
                                   fetchType: ProductListViewController.FetchType.add))
        let filteringState = Observable("")
        let input = ProductListViewModel.Input(productListPageInfoUpdateAction: pageInfo,
                                               filteringStateUpdateAction: filteringState
                                               )
        let output = viewModel.transform(input: input)
        
        output.productListOutput.subscribe { products in
            result = products.first!.name
        }
        
        // when
        output.productListOutput.value = [Product(id: 1, vendorID: 1, name: "test", description: "test", thumbnail: "test", currency: .krw, price: 0.0, bargainPrice: 0.0, discountedPrice: 0.0, stock: 0, createdAt: "", issuedAt: "")]
        
        // then
        XCTAssertEqual(result, "test")
    }
    
    func test_검색된_데이터가_없을_경우확인() {
        // given
        let viewModel = ProductListViewModel(networkAPI: MockSession(result: .success(MockData(fileName: "ProductListMockData").data!)))
        let pageInfo = Observable((pageNumber: 1, itemsPerPage: 5,
                                   fetchType: ProductListViewController.FetchType.add))
        let filteringState = Observable("없는데이터")
        let input = ProductListViewModel.Input(productListPageInfoUpdateAction: pageInfo,
                                               filteringStateUpdateAction: filteringState
                                               )
        let output = viewModel.transform(input: input)

        // when
        let name = output.productListOutput.value.first?.name
        let lowercasedName = output.filteredListOutput.value.first?.name
        
        // then
        XCTAssertEqual(name, "MockProductForTest")
        XCTAssertNotEqual(lowercasedName, "MockProductForTest")
    }
}
