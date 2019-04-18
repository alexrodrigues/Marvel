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

    // MARK: - Variables
    
    private let dispose = DisposeBag()
    private var favorite: CharacterViewModel!
    private var disposeBag = DisposeBag()
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Setup
    
    func setup(character: CharacterViewModel) {
        favorite = character
        loadingState()
        nameLabel.text = character.name
        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: character.profileImageUrl)
        
        character.isFavorite()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] isFavorite in
                guard let self = self else { return }
                self.configureFavorite(isFavorite: isFavorite)
            }).disposed(by: dispose)
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
        favorite.favorite()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.configureFavorite(isFavorite: true)
            }).disposed(by: disposeBag)
    }
    
    @objc func performUnfavorite() {
        favorite.unFavorite()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.configureFavorite(isFavorite: false)
            }).disposed(by: disposeBag)
        
    }
}
