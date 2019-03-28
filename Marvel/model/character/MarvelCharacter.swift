//
//  Character.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation

struct MarvelCharacter: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var resourceURI: String?
    var thumbnail: CharacterThumbnail?
    var comics: CharacterSummary?
    var series: CharacterSummary?
    var stories: CharacterSummary?
    var events: CharacterSummary?
}

struct CharacterThumbnail: Codable {
    var path: String?
    var imageExtension: String?
    
    private enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
}

