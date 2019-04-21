//
//  MarvelViewModel.swift
//  Marvel Widget
//
//  Created by Alex Rodrigues on 21/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation

struct MarvelItemViewModel {
    
    private var _marvelItem: MarvelItem
    
    var resoureUri: String {
        if let resource = _marvelItem.resourceURI {
            return resource.replacingOccurrences(of: "http", with: "https")
        }
        return ""
    }
    
    var name: String {
        return _marvelItem.name ?? ""
    }
    
    init(marvelItem: MarvelItem) {
        _marvelItem = marvelItem
    }
}
