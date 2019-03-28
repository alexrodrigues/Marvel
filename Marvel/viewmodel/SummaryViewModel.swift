//
//  SummaryItemViewModel.swift
//  Marvel
//
//  Created by Alex Rodrigues on 26/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation

class SummaryViewModel {
    
    private var _summary: Summary
    
    var title: String {
        return _summary.title ?? ""
    }
    
    var description: String {
        return _summary.description ?? ""
    }
    
    init(summary: Summary) {
        _summary = summary
    }
    
}
