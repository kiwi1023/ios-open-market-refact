//
//  StubSession.swift
//  ios-open-market-refact-Tests
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import Foundation
@testable import ios_open_market_refact

final class MockNetworkManager: NetworkManagerProtocol {
    let fileName: String
    let isSuccess: Bool
    
    init(fileName: String, isSuccess: Bool) {
        self.fileName = fileName
        self.isSuccess = isSuccess
    }
    
    func dataTask(with request: APIRequest,
                  completionHandler: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            
            guard let self = self,
                  let mockData = StubData(fileName: self.fileName).data else { return }
            
            if self.isSuccess {
                completionHandler(.success(mockData))
            }
            
            completionHandler(.failure(APIError.response))
        }
    }
}

