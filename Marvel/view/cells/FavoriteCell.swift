//
//  FavoriteCell.swift
//  Marvel
//
//  Created by Digital on 27/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var activityIndictorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(favorite: CharacterViewModel, index: Int) {
        loadingState()
        nameLabel.text = favorite.name
        if !favorite.profileImage.isEmpty {
            downloadImage(favorite.profileImage, index: index)
        }
    }
    
    private func loadingState() {
        profileImageView.isHidden = true
        profileImageView.image = nil
        placeholderView.isHidden = false
        activityIndictorView.startAnimating()
    }
    
    private func downloadImage(_ urlImage: String, index: Int) {
        if (!urlImage.isEmpty) {
            ImageService.instance.downloadImage(url: urlImage, index: index) { [weak self] (image, indexFromApi) in
                guard let self = self else { return }
                if index == indexFromApi {
                    self.profileImageView.image = image
                    self.activityIndictorView.stopAnimating()
                    self.profileImageView.isHidden = false
                    self.placeholderView.isHidden = true
                }
            }
        }
    }
}
