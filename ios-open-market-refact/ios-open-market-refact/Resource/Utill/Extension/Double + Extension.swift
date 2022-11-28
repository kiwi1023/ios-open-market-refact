//
//  Double + Extension.swift
//  ios-open-market-refact
//
//  Created by Kiwon Song on 2022/11/11.
//

import Foundation

extension Double {
    func priceFormat(currency : String?) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let price = numberFormatter.string(from: self as NSNumber),
              let currency = currency else {
            return nil
        }
        
        return currency + " " + price
    }
}

extension Double {
    func numberFormattingToDecimal() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
