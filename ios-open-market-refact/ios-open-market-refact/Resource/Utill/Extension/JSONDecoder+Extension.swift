//
//  JSONEncoder+Extension.swift
//  Expo1900
//
//  Created by Kiwi, Finnn on 2022/06/16.
//

import Foundation

extension JSONDecoder {
    static func decodeJson<T: Decodable>(jsonData: Data) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let safeData =  try decoder.decode(T.self, from: jsonData)
            return safeData
        } catch {
            print(error)
            return nil
        }
    }
}
