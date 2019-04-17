//
//  Api.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation
import RxSwift

class Api<T: Decodable> {
    
    private let errorMessage = "Something went wrong on fetching musics"
    
    func requestObject(urlString: String) -> Observable<T> {
        var remoteTask: URLSessionTask!
        guard let url = URL(string: urlString)  else {
            return Observable.error(MyError(msg: self.errorMessage))
        }
        return Observable<T>.create({ observer -> Disposable in
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            remoteTask = URLSession.shared.dataTask(with: urlRequest) { data, _ , error in
                guard let dataReceived = data else {
                    observer.onError(MyError(msg: self.errorMessage))
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
            }
            
            remoteTask.resume()
            
            return Disposables.create {
                remoteTask.cancel()
            }
        })
    }
}
