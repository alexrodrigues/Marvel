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
        guard let summaryText = _summary.title else {
            return "No info"
        }
        if summaryText.isEmpty {
            return "No info"
        }
        return summaryText
    }
    
    var description: String {
        guard let summaryText = _summary.description else {
            return "No info"
        }
        if summaryText.isEmpty {
            return "No info"
        }
        return summaryText
    }
    
    var thumbnailImageUrl: URL? {
        if let image = _summary.thumbnail?.path,
            let imageExtension = _summary.thumbnail?.imageExtension,
            let url = URL(string: "\(image)/portrait_xlarge.\(imageExtension)") {
            return url
        }
        
        return nil
    }
    
    init(summary: Summary) {
        _summary = summary
    }
}
