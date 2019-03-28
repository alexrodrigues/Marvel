//
//  SummaryFactory.swift
//  Marvel
//
//  Created by Alex Rodrigues on 26/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation

class SummaryFactory {

    func factor(response: SummaryResponse) -> SummaryViewModel {
        guard let summaries = response.data?.results else { return SummaryViewModel(summary: Summary()) }
        guard let first =  summaries.first else { return SummaryViewModel(summary: Summary())}
        return SummaryViewModel(summary: first)
    }    
}
