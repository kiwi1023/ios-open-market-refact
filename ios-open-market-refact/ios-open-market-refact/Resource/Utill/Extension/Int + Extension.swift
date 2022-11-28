//
//  String + Extension.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/11/15.
//

import Foundation

extension Int {
    func numberFormattingToDecimal() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
