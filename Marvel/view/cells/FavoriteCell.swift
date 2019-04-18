//
//  FavoriteCell.swift
//  Marvel
//
//  Created by Digital on 27/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class FavoriteCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    private let dispose = DisposeBag()
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Setup
    
    func setup(favorite: CharacterViewModel) {
        loadingState()
        nameLabel.text = favorite.name
        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: favorite.profileImageUrl)
    }
    
    private func loadingState() {
        profileImageView.image = nil
    }

    func didUnHighlight() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
    }
    
    func didHighlight() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.2
        }
    }
}
