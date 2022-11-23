//
//  JsonDecoder.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/11/23.
//

import Foundation

final class JsonDecoderManager {
    public static let shared = JsonDecoderManager()
    private init() {}
    
    func decode<T: Decodable>(from data: Data, to type: T.Type) -> T? {
        if type == String.self {
            return String(data: data, encoding: .utf8) as? T
        }
        let decoder = JSONDecoder()
        var fetchedData: T
        do {
            fetchedData = try decoder.decode(type, from: data)
            return fetchedData
        } catch {
            switch error {
            case DecodingError.typeMismatch(let type, let context):
                debugPrint("\(type.self) ERROR - \(context.debugDescription)")
            case DecodingError.dataCorrupted(let context):
                debugPrint(context.debugDescription)
            case DecodingError.valueNotFound(_ , let context):
                debugPrint(context.debugDescription)
            case DecodingError.keyNotFound(_ , let context):
                debugPrint(context.debugDescription)
            default:
                debugPrint(error.localizedDescription)
            }
            return nil
        }
    }
}
