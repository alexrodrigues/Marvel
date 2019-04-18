//
//  FavoriteViewModel.swift
//  Marvel
//
//  Created by Alex Rodrigues on 18/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct FavoriteViewModel {

    // MARK: - Variables
    var charactersFavorites = BehaviorRelay<[CharacterViewModel]>(value: [CharacterViewModel]())
    var errorMessage = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods to Query
    
    func fetchFavorites() {
        self.charactersFavorites.accept([CharacterViewModel]())
        FavoriteRepository().fetch()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { viewModels in
                self.charactersFavorites.accept(viewModels)
            }, onError: { (error) in
                    self.errorMessage.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
