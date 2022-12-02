//
//  UIImage + Extensioin.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/11/10.
//

import UIKit

extension UIImage {
    func compress() -> Data? {
        guard var compressedImage = self.jpegData(compressionQuality: 0.2) else {
            return nil
        }
        
        while compressedImage.count > 307200 {
            compressedImage = UIImage(data: compressedImage)?.jpegData(compressionQuality: 0.5) ?? Data()
        }
        
        return compressedImage
    }
}
