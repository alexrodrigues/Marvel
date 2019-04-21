//
//  MarvelService.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation

class MarvelService {
    
    internal let LIMIT = 20
    
    public func fabricateDefaultParams() -> String {
        let timestamp = fabricteTimestamp()
        let hash = fabricateApiHash(timestamp: timestamp)
        return "apikey=\(ApiDefinitions.ApiKeys.publicKey.rawValue)&ts=\(timestamp)&hash=\(hash)"
    }
    
    public func fabricateApiHash(timestamp: String) -> String {
        let seed = "\(timestamp)\(ApiDefinitions.ApiKeys.privateKey.rawValue)\(ApiDefinitions.ApiKeys.publicKey.rawValue)"
        return MD5Helper.fabricate(value: seed)
    }
    
    private func fabricteTimestamp() -> String {
        return "\(Date().timeIntervalSince1970)"
    }
}
