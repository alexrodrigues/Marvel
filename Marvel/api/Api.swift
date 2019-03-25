//
//  Api.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxSwift

enum ApiKeys: String {
    case publicKey = "24ee0aeded0cc8ba4b26f8617278fa39"
    case privateKey = "5f34e81bc5e61b93adbdf0b83d882a20341bd8b9"
}

class Api<T: Decodable> {
    
    private let BASE = "https://gateway.marvel.com:443/v1/public/"
    private let ERROR_MESSAGE = "Something went wrong on fetching musics"
    
    func requestObject(endpoint: String) -> Observable<T> {
        var remoteTask: URLSessionTask!
        guard let url = URL(string: "\(self.BASE)\(endpoint)")  else {
            return Observable.error(MyError(msg: self.ERROR_MESSAGE))
        }
        return Observable<T>.create({ observer -> Disposable in
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            remoteTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let dataReceived = data else {
                    observer.onError(MyError(msg: self.ERROR_MESSAGE))
                    observer.onCompleted()
                    return
                }
                do {
                    let objectResponse = try JSONDecoder().decode(T.self, from: dataReceived)
                    observer.onNext(objectResponse)
                    observer.onCompleted()
                } catch let error {
                    observer.onError(MyError(msg: error.localizedDescription))
                    observer.onCompleted()
                }
            };
            remoteTask.resume()
            
            return Disposables.create {
                remoteTask.cancel()
            }
        })
    }
}
