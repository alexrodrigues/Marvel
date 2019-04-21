//
//  ApiSpec.swift
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

class ApiSpec: QuickSpec {
    
    override func spec() {
        describe("Testing API") {
            it("API response is OK", closure: {
                let disposeBag = DisposeBag()
                var resultIsOk = false
                let api = Api<CharactersResponse>()
                waitUntil(timeout: 9.0, action: { (done) in
                    api.requestObject(urlString: "https://gateway.marvel.com/v1/public/characters?limit=20&apikey=24ee0aeded0cc8ba4b26f8617278fa39&ts=1553636467.2847152&hash=ec832342d5673ee1946b5ba122bffea9")
                        .subscribe(onNext: { _ in
                            resultIsOk = true
                        }, onError: { _ in
                            resultIsOk = false
                        }, onCompleted: {
                            expect(resultIsOk).to(equal(true))
                            done()
                        }).disposed(by: disposeBag)
                    
                })
            })
        }
    }
}
