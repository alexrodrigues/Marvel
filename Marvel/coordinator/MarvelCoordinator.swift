//
//  MarvelCoordinator.swift
//  Marvel
//
//  Created by Alex Rodrigues on 19/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

protocol MarvelCoordinatorProtocol: class {
    func start(character: CharacterViewModel)
}

class MarvelCoordinator: NSObject, MarvelCoordinatorProtocol {

    //MARK: - Variables
    
    private var navigationController: UINavigationController
    private var characterViewModel: CharacterViewModel?
    
    //MARK: - Initializers
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: - Navigations
    
    func start(character: CharacterViewModel) {
        self.characterViewModel = character
        let detailViewController = DetailViewController.instantiateFromStoryboard(character: character)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
