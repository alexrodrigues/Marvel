//
//  ListViewModel.swift
//  Marvel
//
//  Created by Alex Rodrigues on 03/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct ListViewModel {

    // MARK: - Variables
    
    var characters = BehaviorRelay<[CharacterViewModel]>(value: [CharacterViewModel]())
    var searchCharacters = BehaviorRelay<[CharacterViewModel]>(value: [CharacterViewModel]())
    var errorMessage = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods to Query
    
    func fetch(lastIndex: Int) {
        CharactersService().fetch(lastIndex: lastIndex)
            .subscribe(onNext: { response in
                    self.characters.accept(response)
                }, onError: { (error) in
                    self.errorMessage.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func search(text: String) {
        CharactersService().search(text: text)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                self.searchCharacters.accept(response)
            }, onError: { (error) in
                self.errorMessage.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
