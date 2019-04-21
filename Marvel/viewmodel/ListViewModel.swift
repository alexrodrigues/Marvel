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
    private var coordinator: MarvelCoordinator?
    
    init(with navigationController: UINavigationController) {
        coordinator = MarvelCoordinator(with: navigationController)
    }
    
    init(with splitController: UISplitViewController) {
        coordinator = MarvelCoordinator(with: splitController)
    }
    
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

// MARK: - CoordinatorLogic

extension ListViewModel {
    
    func navigateToDetail(with character: CharacterViewModel) {
        coordinator?.start(character: character)
    }
    
    func presentiPadLoading() {
        coordinator?.presentiPadLoading()
    }
    
    func presentiPadError(with message: String) {
        coordinator?.presentiPadError(with: message)
    }
    
    func navigateToiPadDetail(with character: CharacterViewModel) {
        coordinator?.navigateToiPadDetail(with: character)
    }
}
