//
//  MD5Helper.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

class MD5Helper {
    static func fabricate(value: String) -> String {
        return value.hashed(.md5) ?? ""
    }
}
