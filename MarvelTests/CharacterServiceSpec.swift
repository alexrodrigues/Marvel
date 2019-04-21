//
//  CharacterService.swift
//  MarvelTests
//
//  Created by Alex Rodrigues on 21/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxCocoa
@testable import Marvel

class CharacterServiceSpec: QuickSpec {

    override func spec() {
        describe("Testing Character Service") {
            it("Testing", closure: {
                let disposeBag = DisposeBag()
                waitUntil(timeout: 9.0, action: { done in
                    CharactersService().fetch(lastIndex: 0)
                        .subscribe(onNext: { (viewModels) in
                            expect(viewModels.count).to(equal(20))
                            done()
                        }).disposed(by: disposeBag)
                })
            })
        }
    }
}
