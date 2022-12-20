//
//  SessionProtocol.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import Foundation

protocol SessionProtocol {
    func dataTask(with request: APIRequest,
                  completionHandler: @escaping (Result<Data, Error>) -> Void)
}
