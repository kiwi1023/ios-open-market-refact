//
//  OpenMarketRequest.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import Foundation

struct OpenMarketRequest: APIRequest {
    var method: HTTPMethod
    var baseURL: String
    var headers: [String : String]?
    var query: [String : String]?
    var body: HTTPBody?
    var path: String
}
