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
    
    private lazy var favoriteRepository = FavoriteRepository()
    
    func fetch(lastIndex: Int) -> Observable<[CharacterViewModel]> {
        let endpoint = "characters?\(fabricateDefaultParams())&limit=\(LIMIT)&offset=\(lastIndex)"
        return Api<CharactersResponse>()
                .requestObject(urlString: "\(ApiDefinitions.BASE_URL)\(endpoint)")
                    .map { CharacterVMFactory().factor(response: $0) }
    }
    
    func insert(character: CharacterViewModel) -> Observable<Bool> {
        return favoriteRepository.save(character: character)
    }
    
    func fetchFavorites() -> Observable<[CharacterViewModel]> {
        return favoriteRepository.fetch()
    }
    
    func search(text: String) -> Observable<[CharacterViewModel]> {
        let endpoint = "characters?\(fabricateDefaultParams())&limit=\(LIMIT)&nameStartsWith=\(text)"
        return Api<CharactersResponse>()
            .requestObject(urlString: "\(ApiDefinitions.BASE_URL)\(endpoint)")
            .map { CharacterVMFactory().factor(response: $0) }
    }
}
