//
//  CharacterViewModelSpec.swift
//  MarvelTests
//
//  Created by Alex Rodrigues on 28/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Quick
import Nimble
@testable import Marvel


class CharacterViewModelSpec: QuickSpec {

    override func spec() {
        describe("CharacterViewModel spec") {
            var viewModel: CharacterViewModel!
            
            beforeEach {
                var model = MarvelCharacter()
                model.id = 900
                model.name = "Spider-man"
                model.thumbnail = CharacterThumbnail(path: "https://marvel-image.com/900", imageExtension: "jpg")
                viewModel = CharacterViewModel(character: model)
            }
            
            it("testing identifier", closure: {
                expect(viewModel.identifier).to(equal(900))
            })
            
            it("testing name", closure: {
                expect(viewModel.name).to(equal("Spider-man"))
            })
            
            it("testing image", closure: {
                expect(viewModel.path).to(equal("https://marvel-image.com/900"))
                expect(viewModel.imageExtension).to(equal("jpg"))
                expect(viewModel.profileImageUrl?.absoluteString).to(equal("https://marvel-image.com/900/portrait_xlarge.jpg"))
            })
        }
    }
}
