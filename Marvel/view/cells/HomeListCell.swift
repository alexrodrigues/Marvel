//
//  HomeListCell.swift
//  Marvel
//
//  Created by Alex Rodrigues on 25/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxSwift

class HomeListCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private let dispose = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(character: CharacterViewModel) {
        loadingState()
        nameLabel.text = character.name
        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: character.profileImageUrl)
    }
    
    private func loadingState() {
        profileImageView.image = nil
    }
    
}
