//
//  CharacterVMFactory.swift
//  Marvel
//
//  Created by Alex Rodrigues on 25/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

class CharacterVMFactory {
    
    func factor(response: CharactersResponse) -> [CharacterViewModel] {
        var viewModels = [CharacterViewModel]()
        guard let characters = response.data?.results else { return [CharacterViewModel]() }
        viewModels = characters.map { CharacterViewModel(character: $0) }
        return viewModels
    }
}
