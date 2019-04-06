//
//  MarvelService.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct ImageDownloadResponse {
    var image: UIImage?
    var index: Int?
    
    init() {
    }
    
    init(provideImage: UIImage, provideIndex: Int) {
        self.image = provideImage
        self.index = provideIndex
    }
}

class ImageService {
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(url: String, index: Int) -> Observable<ImageDownloadResponse> {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            let cacheResponse = ImageDownloadResponse(provideImage: cachedImage, provideIndex: index)
            return Observable.just(cacheResponse)
        }
        return Observable<ImageDownloadResponse>.create({ observer -> Disposable in
            
            if let urlObject = URL(string: url)  {
                do {
                    let data = try Data(contentsOf: urlObject)
                    if let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: url as NSString)
                        let response = ImageDownloadResponse(provideImage: image, provideIndex: index)
                        observer.onNext(response)
                        observer.onCompleted()
                    }
                } catch let exception {
                    observer.onError(MyError(msg: exception.localizedDescription))
                    observer.onCompleted()
                }
            } else {
                observer.onError(MyError(msg: "Failed to download image \(index)"))
                observer.onCompleted()
            }
            
            return Disposables.create {
            }
        })
    }
}
