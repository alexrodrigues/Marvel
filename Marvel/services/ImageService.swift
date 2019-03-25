//
//  MarvelService.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

class ImageService {

    typealias ImageCompletion = (_ image: UIImage?, _ index: Int) -> Void
    
    private var imageCache = NSCache<NSString, UIImage>()
    static let instance = ImageService()
    
    func downloadImage(url: String, index: Int, completion: @escaping ImageCompletion) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(cachedImage, index)
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            guard let urlObject = URL(string: url) else {
                `self`.throwError(index: index, completion: completion)
                return
            }
            do {
                let data = try Data(contentsOf: urlObject)
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: url as NSString)
                        completion(image, index)
                    }
                }
            } catch {
                `self`.throwError(index: index, completion: completion)
            }
        }
    }
    
    private func throwError(index: Int, completion: @escaping ImageCompletion) {
        DispatchQueue.main.async {
            completion(nil, index)
        }
    }
    
}
