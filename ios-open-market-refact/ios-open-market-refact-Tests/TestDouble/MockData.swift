//
//  DummyData.swift
//  ios-open-market-refact-Tests
//
//  Created by 유한석 on 2022/11/10.
//

import Foundation

struct MockData {
    let data: Data?

    init(fileName: String) {
        let location = Bundle.main.url(forResource: fileName, withExtension: "json")
        data = try? Data(contentsOf: location!)
    }
}
