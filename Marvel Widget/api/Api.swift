//
//  Api.swift
//  Marvel Widget
//
//  Created by Alex Rodrigues on 21/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

enum Result<T> {
    case success(T)
    case error(String)
}

class Api<T: Decodable> {
    
    private var remoteTask: URLSessionTask!
    private let errorMessage = "Something went wrong on fetching heroes"
    
    func requestObject(urlString: String, completion: @escaping (Result<T>) -> (Void)) {
        guard let url = URL(string: urlString)  else {
            completion(.error(self.errorMessage))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        remoteTask = URLSession.shared.dataTask(with: urlRequest) { data, _ , error in
            guard let dataReceived = data else {
                completion(.error(self.errorMessage))
                return
            }
            do {
                let objectResponse = try JSONDecoder().decode(T.self, from: dataReceived)
                completion(.success(objectResponse))
            } catch {
                completion(.error(self.errorMessage))
            }
        }
        remoteTask.resume()
    }
}
