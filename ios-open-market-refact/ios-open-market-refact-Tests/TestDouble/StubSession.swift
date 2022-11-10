//
//  StubSession.swift
//  ios-open-market-refact-Tests
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import Foundation
@testable import ios_open_market_refact

final class MockSession: SessionProtocol {
    func dataTask(with request: APIRequest,
                  completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let mockData = MockData(fileName: "ProductListMockData").data else {
            completionHandler(.failure(APIError.response))
            return
        }
        completionHandler(.success(mockData))
    }
}

