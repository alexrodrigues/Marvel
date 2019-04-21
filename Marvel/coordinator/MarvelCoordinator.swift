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

    // MARK: - Variables
    
    private var navigationController: UINavigationController?
    private var splitViewController: UISplitViewController?
    private var ipadDetail: IPadDetailViewController?
    private var characterViewModel: CharacterViewModel?
    
    // MARK: - Initializers
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    init(with splitConroller: UISplitViewController) {
        self.splitViewController = splitConroller
        if let detailVC =  self.splitViewController?.viewControllers[1] as? IPadDetailViewController {
            ipadDetail = detailVC
        } else {
            fatalError("Split Detail View Controller not setted.")
        }
    }
    
    // MARK: - Navigations
    
    func start(character: CharacterViewModel) {
        self.characterViewModel = character
        let detailViewController = DetailViewController.instantiateFromStoryboard(character: character)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    func presentiPadLoading() {
        ipadDetail?.showLoading()
    }
    
    func presentiPadError(with message: String) {
        ipadDetail?.showError(with: message)
    }
    
    func navigateToiPadDetail(with character: CharacterViewModel) {
        ipadDetail?.start(with: character)
    }
}
