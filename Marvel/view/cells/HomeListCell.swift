//
//  HomeListCell.swift
//  Marvel
//
//  Created by Alex Rodrigues on 25/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxSwift

class HomeListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var placeholderView: UIView!
    private let dispose = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(character: CharacterViewModel, index: Int) {
        loadingState()
        nameLabel.text = character.name
        
        character.downloadImage(index)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] imageResponse in
                guard let `self` = self else { return }
                if index == imageResponse.index {
                    `self`.profileImageView.image = imageResponse.image
                    `self`.profileActivityIndicatorView.stopAnimating()
                    `self`.profileImageView.isHidden = false
                    `self`.placeholderView.isHidden = true
                }
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: dispose)
    }
    
    private func loadingState() {
        profileImageView.isHidden = true
        profileImageView.image = nil
        placeholderView.isHidden = false
        profileActivityIndicatorView.startAnimating()
    }
    
}
