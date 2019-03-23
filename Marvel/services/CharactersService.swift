//
//  CharactersService.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CharactersService: MarvelService {
    
    func fetch() -> Observable<CharactersResponse> {
        let endpoint = "characters?\(fabricateDefaultParams())"
        return Api<CharactersResponse>()
                .requestObject(endpoint: endpoint)
    }
}
