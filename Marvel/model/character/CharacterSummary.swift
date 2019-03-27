//
//  CharacterSeries.swift
//  Marvel
//
//  Created by Alex Rodrigues on 26/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation

struct CharacterSummary: Codable {

    var available: Int?
    var collectionURI: String?
    var items: [MarvelItem]?
    
}
