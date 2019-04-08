//
//  FavoriteCell.swift
//  Marvel
//
//  Created by Digital on 27/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxSwift

class FavoriteCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var activityIndictorView: UIActivityIndicatorView!
    
    private let dispose = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(favorite: CharacterViewModel, index: Int) {
        loadingState()
        nameLabel.text = favorite.name
        if !favorite.profileImage.isEmpty {
            favorite.downloadImage(index)
                .asObservable()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] imageResponse in
                    guard let `self` = self else { return }
                    if index == imageResponse.index {
                        `self`.profileImageView.image = imageResponse.image
                        `self`.activityIndictorView.stopAnimating()
                        `self`.profileImageView.isHidden = false
                        `self`.placeholderView.isHidden = true
                    }
                    }, onError: { error in
                        print(error.localizedDescription)
                }).disposed(by: dispose)
        }
    }
    
    private func loadingState() {
        profileImageView.isHidden = true
        profileImageView.image = nil
        placeholderView.isHidden = false
        activityIndictorView.startAnimating()
    }

}
