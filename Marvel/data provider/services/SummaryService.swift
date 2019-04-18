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
    
    func fetch(models: [MarvelItemViewModel]) -> Observable<[SummaryViewModel]> {
        var summariesArray = [SummaryViewModel]()
        return Observable.create({ observer -> Disposable in
            
            var observables = [Observable<SummaryViewModel>]()
            
            models.forEach({ itemVm in
                let observable = self.fetchUnique(marvelItemViewModel: itemVm)
                observables.append(observable)
            })
            
            let requests = Observable.from(observables)
                        .concat()
                .subscribe(onNext: { viewModel in
                    summariesArray.append(viewModel)
                }, onError: { (error) in
                    observer.onError(MyError(msg: error.localizedDescription))
                    observer.onCompleted()
                }, onCompleted: {
                    observer.onNext(summariesArray)
                    observer.onCompleted()
                })
            
            return Disposables.create {
                requests.dispose()
            }
        })
    }

    private func fetchUnique(marvelItemViewModel: MarvelItemViewModel) -> Observable<SummaryViewModel> {
        let resourceUrl = "\(marvelItemViewModel.resoureUri)?\(fabricateDefaultParams())"
        return Api<SummaryResponse>()
            .requestObject(urlString: resourceUrl)
            .map { SummaryFactory().factor(response: $0) }
    }
}
