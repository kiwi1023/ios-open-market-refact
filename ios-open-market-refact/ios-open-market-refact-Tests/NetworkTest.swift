//
//  ios_open_market_refact_Tests.swift
//  ios-open-market-refact-Tests
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import XCTest
@testable import ios_open_market_refact

final class NetworkTest: XCTestCase {
    
    func test_GET_메서드_동작확인() {
        // given
        let expectation = expectation(description: "비동기테스트")
        let session = StubSession()
        var productName: String?
        guard let request = OpenMarketRequestDirector().createGetRequest(pageNumber: 1, itemsPerPage: 100) else { return }
        
        session.dataTask(with: request) { result in
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
    
    func test_POST_메서드_동작확인() {
        //given
        let expectation = expectation(description: "비동기테스트")
        let product = RegistrationProduct(name: "궁극의 푸른눈의 백룡",
                                          description: "공격력 제일쎔",
                                          price: 10000.0,
                                          currency: "KRW",
                                          discountedPrice: 0.0,
                                          stock: 1,
                                          secret: UserInfo.secret)
        let networkManager = NetworkManager()
        guard let assetImage = UIImage(named: "testImage") else { return }
        guard let jpegData = assetImage.compress() else { return }
        
        guard let request = OpenMarketRequestDirector().createPostRequest(product: product, images: [ProductImage(name: "testImage", data: jpegData, type: "jpeg")]) else { return }
        
        networkManager.dataTask(with: request) { result in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
                
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 300)
    }
    
    func test_PATCH_메서드_동작확인() {
        //given
        let expectation = expectation(description: "비동기테스트")
        
        let product = RegistrationProduct(name: "블랙매지션",
                                          description: "마라탕",
                                          price: 15000.0,
                                          currency: "USD",
                                          discountedPrice: 0.0,
                                          stock: 33,
                                          secret: UserInfo.secret)
        let networkManager = NetworkManager()
       
        guard let request = OpenMarketRequestDirector().createPatchRequest(product: product, productNumber: 189) else { return }
        
        networkManager.dataTask(with: request) { result in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 300)
    }

    func test_POST_SecretURI_요청() {
        //given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        let networkManager = NetworkManager()
       
        guard let deleteRequest = OpenMarketRequestDirector().createDeleteURIRequest(productNumber: 189) else { return }
        
        networkManager.dataTask(with: deleteRequest) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
            case .failure(let error):
                print(error)
                break
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 300)
    }

    func test_DELETE_메서드_동작확인() {
        // given
        let expectation = expectation(description: "비동기 요청을 기다림.")
        let networkManager = NetworkManager()
        guard let deleteRequest = OpenMarketRequestDirector().createDeleteRequest(with: "MTg5fDU3MDNjODU4LTYxMTAtMTFlZC1hOTE3LTYxZDNlYmI5MDA4MQ") else { return }
        
        networkManager.dataTask(with: deleteRequest) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(String(decoding: success, as: UTF8.self))
            case .failure(let error):
                print(error)
                break
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 300)
    }
}
