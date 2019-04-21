//
//  TodayViewModel.swift
//  Marvel Widget
//
//  Created by Alex Rodrigues on 21/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

class TodayViewModel: NSObject {

    typealias ViewModelCompletion = (_ heroes: [CharacterViewModel], _ errorMesssage: String) -> Void
    private let characterService = TodayService()
    
    func fetch(completion: @escaping ViewModelCompletion) {
        characterService.fetch { (viewModels, errorMessage) in
            completion(viewModels, errorMessage)
        }
    }
}
