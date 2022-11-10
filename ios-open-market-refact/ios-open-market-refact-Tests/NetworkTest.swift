//
//  ios_open_market_refact_Tests.swift
//  ios-open-market-refact-Tests
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import XCTest
@testable import ios_open_market_refact

final class NetworkTest: XCTestCase {
    
    let boundary = "Boundary-\(UUID().uuidString)"
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
        let session = StubSession()
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
    
    func test_POST_메서드_동작확인() {
        //given
        let expectation = expectation(description: "비동기테스트")
        guard let assetImage = UIImage(named: "testImage") else { return }
        guard let jpegData = assetImage.compress() else { return }
        
        let product = RegistrationProduct(name: "궁극의 푸른눈의 백룡",
                                          description: "공격력 제일쎔",
                                          price: 10000.0,
                                          currency: "KRW",
                                          discountedPrice: 0.0,
                                          stock: 1,
                                          secret: UserInfo.secret.text)
        
        guard let productData = try? JSONEncoder().encode(product) else { return }
        
        let multiPartFormData = MultiPartForm(
            boundary: boundary,
            jsonData: productData,
            images: [ProductImage(name: "testImage", data: jpegData, type: "jpeg")]
        )
        
        let networkManager = NetworkManager()
        let request = OpenMarketRequest(
            method: .post,
            baseURL: URLHost.openMarket.url,
            headers: ["identifier": UserInfo.identifier.text, "Content-Type": "multipart/form-data; boundary=\(boundary)"],
            body: .multiPartForm(multiPartFormData),
            path: URLAdditionalPath.product.value
        )
        
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
                                          secret: UserInfo.secret.text)
        guard let productData = try? JSONEncoder().encode(product) else { return }
        let networkManager = NetworkManager()
        let request = OpenMarketRequest(
            method: .patch,
            baseURL: URLHost.openMarket.url,
            headers: ["identifier": UserInfo.identifier.text, "Content-Type": "application/json"],
            body: .json(productData),
            
            path: URLAdditionalPath.product.value + "/181/"
        )
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
        let body = ProductDeleteKey(secret: UserInfo.secret.text)
        guard let data = try? JSONEncoder().encode(body) else { return }
        let deleteRequest = OpenMarketRequest(
            method: .post,
            baseURL: URLHost.openMarket.url,
            headers: ["identifier": UserInfo.identifier.text, "Content-Type": "application/json"],
            body: .json(data),
            path: URLAdditionalPath.product.value + "/181/archived"
        )
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
        let deleteRequest = OpenMarketRequest(
            method: .delete,
            baseURL: URLHost.openMarket.url,
            headers: ["identifier": UserInfo.identifier.text,
                      "Content-Type" : "application/json"],
            path: URLAdditionalPath.product.value + "/MTgxfGI0MGU3ZWYwLTYwZmItMTFlZC1hOTE3LTQxYTQ3YmFmMDM1NQ"
        )
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
