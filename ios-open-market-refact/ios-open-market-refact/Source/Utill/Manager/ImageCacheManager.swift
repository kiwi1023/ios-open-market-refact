//
//  ImageCacheManager.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/23.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var waitingResponseClosure = [NSURL: [(UIImage) -> Void]]()
    private var dataTasks = [NSURL: URLSessionDataTask]()
    
    private func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func load(url: NSURL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        if waitingResponseClosure[url] != nil {
            return
        } else {
            waitingResponseClosure[url] = [completion]
        }
        
        let urlSession = URLSession(configuration: .ephemeral)
        let task = urlSession.dataTask(with: url as URL) { data, response, error in
            guard let responseData = data,
                  let image = UIImage(data: responseData),
                  let blocks = self.waitingResponseClosure[url], error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            for block in blocks {
                DispatchQueue.main.async {
                    block(image)
                }
            }
            return
        }
        dataTasks[url] = task
        dataTasks[url]?.resume()
    }
    
    func loadBannerImage(url: NSURL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        let urlSession = URLSession(configuration: .ephemeral)
        let task = urlSession.dataTask(with: url as URL) { data, response, error in
            guard let responseData = data,
                  let image = UIImage(data: responseData)
            else { return }
            
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }
        dataTasks[url] = task
        dataTasks[url]?.resume()
    }
    
    func cancel(url: NSURL) {
        dataTasks[url]?.cancel()
        dataTasks[url] = nil
        dataTasks.removeValue(forKey: url)
        waitingResponseClosure[url] = []
        waitingResponseClosure.removeValue(forKey: url)
    }
}
