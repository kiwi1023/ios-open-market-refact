//
//  MultiPartForm.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/12/02.
//

import Foundation

struct MultiPartForm {
    let boundary: String
    let jsonData: Data
    let images: [ProductImage]
}
