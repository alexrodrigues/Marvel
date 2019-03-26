//
//  SummaryService.swift
//  Marvel
//
//  Created by Alex Rodrigues on 26/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SummaryService: MarvelService {

    func fetch(marvelItemViewModel: MarvelItemViewModel) -> Observable<[SummaryViewModel]> {
        var resourceUrl = marvelItemViewModel.resoureUri
        resourceUrl = resourceUrl.replacingOccurrences(of: ApiDefinitions.BASE_URL, with: "")
        resourceUrl = "/?\(fabricateDefaultParams())"
        return Api<SummaryResponse>()
            .requestObject(endpoint: resourceUrl)
            .map { SummaryFactory().factor(response: $0) }
    }
}
