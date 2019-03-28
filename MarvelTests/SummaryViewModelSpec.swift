//
//  SummaryViewModelSpec.swift
//  MarvelTests
//
//  Created by Alex Rodrigues on 28/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import Quick
import Nimble
@testable import Marvel

class SummaryViewModelSpec: QuickSpec {

    override func spec() {
        describe("SummaryViewModel spec") {
            var viewModel: SummaryViewModel!
            
            beforeEach {
                var model = Summary()
                model.title = "Spider-man"
                model.description = "Spider-man is one of more resilient heroes of Marvel's universe"
                viewModel = SummaryViewModel(summary: model)
            }
            
            it("testing name", closure: {
                expect(viewModel.title).to(equal( "Spider-man"))
            })
            
            it("testing description", closure: {
                expect(viewModel.description).to(equal("Spider-man is one of more resilient heroes of Marvel's universe"))
            })
        }
    }
}
