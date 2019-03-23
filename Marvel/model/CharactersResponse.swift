//
//  CharactersResponse.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation

struct CharactersResponse: Codable {
    var attributionText: String?
    var data: CharactersData?
}


struct CharactersData: Codable {
    var offset: Int?
    var limit: Int?
    var results: [Character]?
}
