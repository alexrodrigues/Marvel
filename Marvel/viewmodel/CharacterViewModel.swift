//
//  CharacterViewModel.swift
//  Marvel
//
//  Created by Alex Rodrigues on 25/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation

struct CharacterViewModel {

    private var _character: Character
    
    var name: String {
        return _character.name ?? ""
    }
    
    var profileImage: String {
        if let image = _character.thumbnail?.path,
                let imageExtension = _character.thumbnail?.imageExtension {
            return "\(image)/portrait_xlarge.\(imageExtension)"
        }
        return ""
    }
    
    var comicsUris = [MarvelItemViewModel]()
    
    var eventsUris = [MarvelItemViewModel]()
    
    var storiesUris = [MarvelItemViewModel]()
    
    var seriesUris = [MarvelItemViewModel]()
    
    
    init(character: Character) {
        _character = character
    }
}
