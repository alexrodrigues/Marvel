//
//  HomeTableCell.swift
//  Marvel
//
//  Created by Alex Rodrigues on 20/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxSwift

class HomeTableCell: UITableViewCell {

    // MARK: - Variables
    
    private var character: CharacterViewModel!
    private var disposeBag  = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(with characterViewModel: CharacterViewModel) {
        self.character = characterViewModel
        
        thumbnailImageView.backgroundColor = .clear
        nameLabel.text = characterViewModel.name
        
        if let url = characterViewModel.profileImageUrl {
            thumbnailImageView.kf.indicatorType = .activity
            thumbnailImageView.kf.setImage(with: url)
        } else {
            thumbnailImageView.backgroundColor = .darkGray
        }
        
        character.isFavorite()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] isFavorite in
                guard let self = self else { return }
                self.configureFavorite(isFavorite: isFavorite)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Favorite Actions
    
    private func configureFavorite(isFavorite: Bool) {
        if isFavorite {
            favoriteButton.addTarget(self, action: #selector(HomeListCell.performUnfavorite), for: .touchUpInside)
            favoriteButton.setTitle("Unfavorite", for: .normal)
        } else {
            favoriteButton.addTarget(self, action: #selector(HomeListCell.performFavorite), for: .touchUpInside)
            favoriteButton.setTitle("Favorite", for: .normal)
        }
    }
    
    @objc func performFavorite() {
        character.favorite()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.configureFavorite(isFavorite: true)
            }).disposed(by: disposeBag)
    }
    
    @objc func performUnfavorite() {
        character.unFavorite()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.configureFavorite(isFavorite: false)
            }).disposed(by: disposeBag)
        
    }
}
