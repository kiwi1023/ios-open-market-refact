//
//  UILable + Extension.swift
//  ios-open-market-refact
//
//  Created by Kiwon Song on 2022/11/11.
//

import UIKit

extension UILabel {
    func addStrikethrough() {
        guard let text = self.text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        
        attributeString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length)
        )
        
        attributedText = attributeString
    }
}
