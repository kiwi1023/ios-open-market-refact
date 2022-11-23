//
//  ImageCacheManager.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/11/23.
//

import UIKit

public class ImageCache {
    public static let shared = ImageCache()
    private init() {}
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var waitingRespoinseClosure = [NSURL: [(UIImage) -> Void]]()
    private var dataTasks = [NSURL: URLSessionDataTask]()
    
    private final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    final func load(url: NSURL, completion: @escaping (UIImage?) -> Void) {
        // Cache에 저장된 이미지가 있는 경우
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        if waitingRespoinseClosure[url] != nil {
            return
        } else {
            waitingRespoinseClosure[url] = [completion]
        }
        
        // .epemeral: 따로 NSCache를 사용하기 때문에 URLSession에서 cache를 사용하지 않게끔 설정
        let urlSession = URLSession(configuration: .ephemeral)
        let task = urlSession.dataTask(with: url as URL) { data, response, error in
            guard let responseData = data,
                  let image = UIImage(data: responseData),
                  let blocks = self.waitingRespoinseClosure[url], error == nil else {
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
        task.resume()
    }
    
    final func cancel(url: NSURL) {
        dataTasks[url]?.cancel()
        dataTasks[url] = nil
        dataTasks.removeValue(forKey: url)
        waitingRespoinseClosure[url] = []
        waitingRespoinseClosure.removeValue(forKey: url)
    }
}
