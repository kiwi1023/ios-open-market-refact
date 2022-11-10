//
//  Data + Extension.swift
//  ios-open-market-refact
//
//  Created by Kiwon Song on 2022/11/10.
//

import Foundation

extension Data {
    mutating func append(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        
        self.append(data)
    }
}
