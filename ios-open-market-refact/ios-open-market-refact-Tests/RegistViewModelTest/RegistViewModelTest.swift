//
//  RegistViewModelTest.swift
//  ios-open-market-refact-Tests
//
//  Created by 이은찬 on 2022/12/20.
//

import XCTest
@testable import ios_open_market_refact

final class RegistViewModelTest: XCTestCase {
    
    struct MockSession: SessionProtocol {
        var result: Result<Data, Error>
        func dataTask(with request: APIRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
            completionHandler(result)
        }
    }
    
    func test_post_결과_확인() {
        // given
        let viewModel = ProductRegistViewModel(networkAPI: MockSession(result: .success(MockData(fileName: "ProductListMockData").data!)))
        let product = RegistrationProduct(name: "", description: "", price: 0, currency: "", discountedPrice: 0, stock: 0, secret: "")
        let postAction = Observable<(RegistrationProduct?, [ProductImage], Update)>((product, [], .updatable))
        let patchAction = Observable<(RegistrationProduct?, Update)>((product, .unUpdatable))
        let input = ProductRegistViewModel.Input(postAction: postAction,
                                                 patchAction: patchAction)
        let output = viewModel.transform(input: input)
        
        var result = false
        
        // when
        output.doneAction.subscribe { bool in
            result = bool
        }
        
        // then
        XCTAssertEqual(result, true)
    }
    
    func test_patch_결과_확인() {
        // given
        let viewModel = ProductRegistViewModel(networkAPI: MockSession(result: .success(MockData(fileName: "ProductListMockData").data!)))
        let product = RegistrationProduct(name: "", description: "", price: 0, currency: "", discountedPrice: 0, stock: 0, secret: "")
        let postAction = Observable<(RegistrationProduct?, [ProductImage], Update)>((product, [], .unUpdatable))
        let patchAction = Observable<(RegistrationProduct?, Update)>((product, .updatable))
        let input = ProductRegistViewModel.Input(postAction: postAction,
                                                 patchAction: patchAction)
        let output = viewModel.transform(input: input)
        
        var result = false
        
        // when
        output.doneAction.subscribe { bool in
            result = bool
        }
        
        // then
        XCTAssertEqual(result, true)
    }
    
    func test_post_patch_둘_다_action이_없을때() {
        // given
        let viewModel = ProductRegistViewModel(networkAPI: MockSession(result: .success(MockData(fileName: "ProductListMockData").data!)))
        let product = RegistrationProduct(name: "", description: "", price: 0, currency: "", discountedPrice: 0, stock: 0, secret: "")
        let postAction = Observable<(RegistrationProduct?, [ProductImage], Update)>((product, [], .unUpdatable))
        let patchAction = Observable<(RegistrationProduct?, Update)>((product, .unUpdatable))
        let input = ProductRegistViewModel.Input(postAction: postAction,
                                                 patchAction: patchAction)
        let output = viewModel.transform(input: input)
        
        var result = true
        
        // when
        output.doneAction.subscribe { bool in
            result = bool
        }
        
        // then
        XCTAssertEqual(result, false)
    }
}
