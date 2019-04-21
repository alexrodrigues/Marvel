//
//  SummaryResponse.swift
//  Marvel
//
//  Created by Alex Rodrigues on 26/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

struct SummaryResponse: Codable {
    var attributionText: String?
    var data: SummaryData?
}

struct SummaryData: Codable {
    var offset: Int?
    var limit: Int?
    var results: [Summary]?
}
