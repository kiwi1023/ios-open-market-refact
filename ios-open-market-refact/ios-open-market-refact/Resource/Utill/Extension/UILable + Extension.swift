//
//  UILable + Extension.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/11.
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
