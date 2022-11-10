//
//  ios_open_market_refact_Tests.swift
//  ios-open-market-refact-Tests
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import XCTest
@testable import ios_open_market_refact

final class NetworkTest: XCTestCase {
    var sut: OpenMarketRequest!
    
    override func setUpWithError() throws {
        sut = OpenMarketRequest(
            method: .get,
            baseURL: URLHost.openMarket.url,
            path: ""
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_GET_메서드_동작확인() {
        // given
        let expectation = expectation(description: "비동기테스트")
        let session = MockSession()
        var productName: String?
        
        session.dataTask(with: sut) { result in
            switch result {
            case .success(let data):
                let decodedData = try? JSONDecoder().decode(ProductList.self, from: data)
                productName = decodedData?.pages[0].name ?? ""
            case .failure(let error):
                print(error)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        // when
        let result = "MockProductForTest"
        
        // then
        XCTAssertEqual(productName, result)
    }
    
}
