//
//  SummaryFactory.swift
//  Marvel
//
//  Created by Alex Rodrigues on 26/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation

class SummaryFactory {

    func factor(response: SummaryResponse) -> [SummaryViewModel] {
        var viewModels = [SummaryViewModel]()
        guard let summaries = response.data?.results else { return [SummaryViewModel]() }
        viewModels = summaries.map { SummaryViewModel(summary: $0) }
        return viewModels
    }
    
}
