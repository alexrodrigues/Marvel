//
//  MarvelItemViewModelSpec.swift
//  MarvelTests
//
//  Created by Alex Rodrigues on 28/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Quick
import Nimble
@testable import Marvel

class MarvelItemViewModelSpec: QuickSpec {

    override func spec() {
        describe("MarvelItemViewModel spec") {
            var viewModel: MarvelItemViewModel!
            
            beforeEach {
                var model = MarvelItem()
                model.name = "Spider-man"
                model.resourceURI = "http://gateway.marvel.com/v1/public/comics/21366"
                viewModel = MarvelItemViewModel(marvelItem: model)
            }
            
            it("testing name", closure: {
                expect(viewModel.name).to(equal( "Spider-man"))
            })
            
            it("testing resourceUri with https", closure: {
                expect(viewModel.resoureUri).to(equal("https://gateway.marvel.com/v1/public/comics/21366"))
            })
        }
    }
}
