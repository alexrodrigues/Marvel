//
//  ApiDefinitions.swift
//  Marvel
//
//  Created by Alex Rodrigues on 26/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation

struct ApiDefinitions {
    static let BASE_URL = "https://gateway.marvel.com:443/v1/public/"
    
    enum ApiKeys: String {
        case publicKey = "24ee0aeded0cc8ba4b26f8617278fa39"
        case privateKey = "5f34e81bc5e61b93adbdf0b83d882a20341bd8b9"
    }
}
