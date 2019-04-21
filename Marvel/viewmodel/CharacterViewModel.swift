//
//  CharacterViewModel.swift
//  Marvel
//
//  Created by Alex Rodrigues on 25/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct CharacterViewModel {
    
    private var _character: MarvelCharacter
    private var repository: FavoriteRepository!
    var updateFavorite = BehaviorRelay<Bool>(value: false)
    private var disposeBag = DisposeBag()
    
    var identifier: Int {
        return _character.id ?? 0
    }
    
    var name: String {
        return _character.name ?? ""
    }
    
    var profileImageUrl: URL? {
        if let image = _character.thumbnail?.path,
            let imageExtension = _character.thumbnail?.imageExtension,
            let url = URL(string: "\(image)/portrait_xlarge.\(imageExtension)") {
            return url
        }
        
        return nil
    }
    
    var path: String {
        return _character.thumbnail?.path ?? ""
    }
    
    var imageExtension: String {
        return _character.thumbnail?.imageExtension ?? ""
    }
    
    var comicsUris: [MarvelItemViewModel]!
    
    var eventsUris: [MarvelItemViewModel]!
    
    var storiesUris: [MarvelItemViewModel]!
    
    var seriesUris: [MarvelItemViewModel]!
    
    init(character: MarvelCharacter) {
        _character = character
        repository = FavoriteRepository()
    }
    
    func isFavorite() -> Observable<Bool> {
        return repository.find(character: self)
                    .map { !$0.isEmpty }
    }
    
    func favorite() -> Observable<Bool> {
         return repository.insert(character: self)
    }
    
    func unFavorite() -> Observable<Bool> {
        return repository.delete(character: self)
    }
}
