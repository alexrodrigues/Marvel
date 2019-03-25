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
        if let image = _character.resourceURI {
            return "\(image)/portrait_xlarge.jpg"
        }
        return ""
    }
    
    init(character: Character) {
        _character = character
    }
}
