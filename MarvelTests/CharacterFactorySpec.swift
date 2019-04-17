//
//  CharacterFactorySpec.swift
//  MarvelTests
//
//  Created by Alex Rodrigues on 28/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Quick
import Nimble
@testable import Marvel

class CharacterFactorySpec: QuickSpec {

    override func spec() {
        
        var viewModels: [CharacterViewModel]!
        
        describe("CharacterFactory Spec") {
            
            
            beforeEach {
                
                var models = [MarvelCharacter]()
                
                var spiderMan = MarvelCharacter()
                spiderMan.id = 900
                spiderMan.name = "Spider-man"
                spiderMan.thumbnail = CharacterThumbnail(path: "https://marvel-image.com/900", imageExtension: "jpg")
                models.append(spiderMan)
                
                var ironMan = MarvelCharacter()
                ironMan.id = 901
                ironMan.name = "Iron man"
                ironMan.thumbnail = CharacterThumbnail(path: "https://marvel-image.com/901", imageExtension: "jpg")
                models.append(ironMan)
                
                var hulk = MarvelCharacter()
                hulk.id = 902
                hulk.name = "Hulk"
                hulk.thumbnail = CharacterThumbnail(path: "https://marvel-image.com/902", imageExtension: "jpg")
                models.append(hulk)
                
                let data = CharactersData(offset: 0, limit: 3, results: models)
                let response = CharactersResponse(attributionText: "Data provided by Marvel. © 2019 MARVEL", data: data)
                
                viewModels = CharacterVMFactory().factor(response: response)
            }

            it("testing counting", closure: {
                expect(viewModels.count).to(equal(3))
            })
            
            it("testing spiderman", closure: {
                expect(viewModels.first?.identifier).to(equal(900))
                expect(viewModels.first?.name).to(equal("Spider-man"))
                expect(viewModels.first?.path).to(equal("https://marvel-image.com/900"))
                expect(viewModels.first?.imageExtension).to(equal("jpg"))
                expect(viewModels.first?.profileImageUrl?.absoluteString).to(equal("https://marvel-image.com/900/portrait_xlarge.jpg"))
            })
            
            it("testing ironman", closure: {
                expect(viewModels[1].identifier).to(equal(901))
                expect(viewModels[1].name).to(equal("Iron man"))
                expect(viewModels[1].path).to(equal("https://marvel-image.com/901"))
                expect(viewModels[1].imageExtension).to(equal("jpg"))
                expect(viewModels[1].profileImageUrl?.absoluteString).to(equal("https://marvel-image.com/901/portrait_xlarge.jpg"))
            })
            
            it("testing hulk", closure: {
                expect(viewModels[2].identifier).to(equal(902))
                expect(viewModels[2].name).to(equal("Hulk"))
                expect(viewModels[2].path).to(equal("https://marvel-image.com/902"))
                expect(viewModels[2].imageExtension).to(equal("jpg"))
                expect(viewModels[2].profileImageUrl?.absoluteString).to(equal("https://marvel-image.com/902/portrait_xlarge.jpg"))
            })
        }
        
        
    }
}
