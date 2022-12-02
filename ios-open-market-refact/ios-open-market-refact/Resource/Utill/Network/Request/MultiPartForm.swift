//
//  MultiPartForm.swift
//  ios-open-market-refact
//
//  Created by Kiwon Song on 2022/12/02.
//

import Foundation

struct MultiPartForm {
    let boundary: String
    let jsonData: Data
    let images: [ProductImage]
}
