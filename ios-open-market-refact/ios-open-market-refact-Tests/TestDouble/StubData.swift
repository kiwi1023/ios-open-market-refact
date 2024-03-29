//
//  DummyData.swift
//  ios-open-market-refact-Tests
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import Foundation

struct StubData {
    let data: Data?

    init(fileName: String) {
        let location = Bundle.main.url(forResource: fileName, withExtension: "json")
        data = try? Data(contentsOf: location!)
    }
}
