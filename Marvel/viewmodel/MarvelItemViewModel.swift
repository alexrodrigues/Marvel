//
//  MarvelItemViewModel.swift
//  Marvel
//
//  Created by Alex Rodrigues on 26/03/19.
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
