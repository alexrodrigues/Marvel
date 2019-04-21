//
//  TodayService.swift
//  Marvel Widget
//
//  Created by Alex Rodrigues on 21/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

class TodayService: MarvelService {
    
    typealias ServiceCompletion = (_ heroes: [CharacterViewModel], _ errorMesssage: String) -> Void
    
    func fetch(completion: @escaping ServiceCompletion) {
        let endpoint = "characters?\(fabricateDefaultParams())&limit=\(LIMIT)&offset=\(0)"
        let urlString = "\(ApiDefinitions.baseUrl)\(endpoint)"
        Api<CharactersResponse>().requestObject(urlString: urlString) { (result) -> (Void) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    completion(CharacterVMFactory().factor(response: response), "")
                }
            case .error(let errorMessage):
                DispatchQueue.main.async {
                    completion([CharacterViewModel](), errorMessage)
                }
            }
        }
    }
}
