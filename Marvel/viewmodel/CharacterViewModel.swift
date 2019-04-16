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
    
    var identifier: Int {
        return _character.id ?? 0
    }
    
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
    
    
    func downloadImage(_ anIndex: Int? = -1) -> Observable<ImageDownloadResponse> {
        return ImageService()
            .downloadImage(url: profileImage, index: anIndex ?? -1)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    init(character: MarvelCharacter) {
        _character = character
    }
}
