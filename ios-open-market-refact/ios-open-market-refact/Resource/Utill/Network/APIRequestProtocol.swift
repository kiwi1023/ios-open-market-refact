//
//  APIRequestProtocol.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import Foundation

enum URLHost {
    case openMarket
    
    var url: String {
        switch self {
        case .openMarket:
            return "https://openmarket.yagom-academy.kr"
        }
    }
}

enum URLAdditionalPath {
    case healthChecker
    case product
    
    var value: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .product:
            return "/api/products"
        }
    }
}

protocol APIRequest {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var headers: [String: String]? { get }
    var query: [String: String]? { get }
    var body: Data? { get }
    var path: String { get }
}

extension APIRequest {
    var url: URL? {        
        var urlComponents = URLComponents(string: baseURL + path)
        urlComponents?.queryItems = query?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        return urlComponents?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpBody = body
        urlRequest.httpMethod = method.type
        headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
}
