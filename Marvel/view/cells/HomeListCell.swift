//
//  HomeListCell.swift
//  Marvel
//
//  Created by Alex Rodrigues on 25/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

class HomeListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var placeholderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(character: CharacterViewModel, index: Int) {
        loadingState()
        nameLabel.text = character.name
        downloadImage(character.profileImage, index: index)
    }
    
    private func loadingState() {
        profileImageView.isHidden = true
        profileImageView.image = nil
        placeholderView.isHidden = false
        profileActivityIndicatorView.startAnimating()
    }
    
    private func downloadImage(_ urlImage: String, index: Int) {
        if (!urlImage.isEmpty) {
            ImageService.instance.downloadImage(url: urlImage, index: index) { [weak self] (image, indexFromApi) in
                guard let `self` = self else { return }
                if index == indexFromApi {
                    `self`.profileImageView.image = image
                    `self`.profileActivityIndicatorView.stopAnimating()
                    `self`.profileImageView.isHidden = false
                    `self`.placeholderView.isHidden = true
                }
            }
        }
    }
}
