//
//  DownloadableUIImageView.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/11/17.
//

import UIKit

final class DownloadableUIImageView: UIImageView {
    var dataTask: URLSessionDataTask?
    
    func setImageUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        
        self.image = UIImage()
        self.dataTask = URLSession.shared.dataTask(with: url) { (data, result, error) in
            guard error == nil else {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage()
                }
                return
            }
            DispatchQueue.main.async { [weak self] in
                if let data = data, let image = UIImage(data: data) {
                    self?.image = image
                }
            }
        }
        self.dataTask?.resume()
    }
    
    func cancelImageDownload() {
        dataTask?.cancel()
        dataTask = nil
    }
}
