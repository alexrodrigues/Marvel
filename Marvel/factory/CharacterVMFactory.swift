//
//  CharacterVMFactory.swift
//  Marvel
//
//  Created by Alex Rodrigues on 25/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation

class CharacterVMFactory {
    
    func factor(response: CharactersResponse) -> [CharacterViewModel] {
        var viewModels = [CharacterViewModel]()
        guard let characters = response.data?.results else { return [CharacterViewModel]() }
        viewModels = characters.map {
            var response = CharacterViewModel(character: $0)
            if let comics = $0.comics?.items {
                response.comicsUris = convertToJsonUris(items: comics)
            }
            if let events = $0.events?.items {
                response.eventsUris = convertToJsonUris(items: events)
            }
            if let stories = $0.stories?.items {
                response.storiesUris = convertToJsonUris(items: stories)
            }
            if let series = $0.series?.items {
                response.seriesUris = convertToJsonUris(items: series)
            }
            return response
        }
        return viewModels
    }
    
    private func convertToJsonUris(items: [MarvelItem]) -> [MarvelItemViewModel] {
        return items.map{ MarvelItemViewModel(marvelItem: $0) }
    }
}
