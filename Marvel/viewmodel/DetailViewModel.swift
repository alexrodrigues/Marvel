//
//  DetailViewModel.swift
//  Marvel
//
//  Created by Alex Rodrigues on 03/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct DetailViewModel {
    
    let sectionTitles = ["Comics", "Events", "Stories", "Series"]
    
    var comicsArray = BehaviorRelay<[SummaryViewModel]>(value: [SummaryViewModel]())
    var eventsArray = BehaviorRelay<[SummaryViewModel]>(value: [SummaryViewModel]())
    var storiesArray = BehaviorRelay<[SummaryViewModel]>(value: [SummaryViewModel]())
    var seriesArray = BehaviorRelay<[SummaryViewModel]>(value: [SummaryViewModel]())
    
    var errorMessage = BehaviorRelay<String>(value: "")
    
    private let disposeBag = DisposeBag()
    
    
    func fetch(character: CharacterViewModel) {
        
        SummaryService()
            .fetch(models: character.comicsUris)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { viewModels in
                self.comicsArray.accept(viewModels)
                }, onError: { error in
                    self.errorMessage.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        SummaryService()
            .fetch(models: character.eventsUris)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { viewModels in
                self.eventsArray.accept(viewModels)
            }, onError: { error in
                self.errorMessage.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        SummaryService()
            .fetch(models: character.storiesUris)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { viewModels in
                self.storiesArray.accept(viewModels)
            }, onError: { error in
                self.errorMessage.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        SummaryService()
            .fetch(models: character.seriesUris)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { viewModels in
                self.seriesArray.accept(viewModels)
            }, onError: { error in
                self.errorMessage.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
        
    }
    
    func isCharacterExists(character: CharacterViewModel)  -> Observable<Bool> {
        return CharactersService().exists(character: character)
    }
    
    func insert(character: CharacterViewModel) -> Observable<Bool>  {
        return CharactersService().insert(character: character)
    }
    
    func delete(character: CharacterViewModel) -> Observable<Bool> {
        return CharactersService().delete(character: character)
    }
}
