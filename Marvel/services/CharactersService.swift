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
    
    func fetch(lastIndex: Int) -> Observable<[CharacterViewModel]> {
        let endpoint = "characters?\(fabricateDefaultParams())&limit=\(LIMIT)&offset=\(lastIndex)"
        return Api<CharactersResponse>()
                .requestObject(endpoint: endpoint)
                    .map { CharacterVMFactory().factor(response: $0) }
    }
}
