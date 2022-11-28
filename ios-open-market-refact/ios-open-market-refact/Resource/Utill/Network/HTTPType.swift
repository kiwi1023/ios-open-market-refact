//
//  HTTPType.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import Foundation

enum HTTPMethod {
    case get
    case post
    case delete
    case patch
    case put
    
    var type: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        }
    }
}

enum URLHost {
    case openMarket
    
    var url: String {
        switch self {
        case .openMarket:
            return "https://openmarket.yagom-academy.kr"
        }
    }
}

enum HTTPQuery {
    case getProducts(_ pageNumber: Int,_ itemsPerPage: Int)
    
    var quary: [String: String] {
        switch self {
        case .getProducts(let pageNumber, let itemsPerPage):
            return ["page_no": "\(pageNumber)", "items_per_page": "\(itemsPerPage)"]
        }
    }
}

enum HTTPHeader {
    case delete
    case json
    case multiPartForm(_ boundary: String)
    
    var header: [String: String] {
        switch self {
        case .delete:
            return ["identifier": UserInfo.identifier]
        case .json:
            return ["Content-Type": "application/json",
                    "identifier": UserInfo.identifier]
        case .multiPartForm(let boundary):
            return ["Content-Type": "multipart/form-data; boundary=\(boundary)",
                    "identifier": UserInfo.identifier]
        }
    }
}

enum HTTPPath {
    case healthChecker
    case product
    case productDetail(_ productNumber: Int)
    case getDeleteURI(_ productNumber: Int)
    case delete(_ deleteURL: String)
    
    var value: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .product:
            return "/api/products"
        case .productDetail(let productNumber):
            return "/api/products/\(productNumber)/"
        case .getDeleteURI(let productNumber):
            return "/api/products/\(productNumber)/archived"
        case .delete(let deleteURI):
            return"\(deleteURI)"
        }
    }
}

enum HTTPBody {
    case multiPartForm(_ form: MultiPartForm)
    case json(_ json: Data)
}
