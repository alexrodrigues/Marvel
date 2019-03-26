//
//  DetailViewController.swift
//  Marvel
//
//  Created by Alex Rodrigues on 26/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activtiyIndicatorView: UIActivityIndicatorView!
    
    var character: CharacterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.navigationItem.title = character.name
        nameLabel.text = character.name
        ImageService.instance.downloadImage(url: character.profileImage, index: 0) { [weak self] (image, indexFromApi) in
            guard let self = self else { return }
            self.profileImageView.image = image
        }
    }
    
    private func fetch() {
        
    }

}
