//
//  SummaryCell.swift
//  Marvel
//
//  Created by Alex Rodrigues on 19/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

class SummaryCell: UITableViewCell {

    // MARK: - Variables
    
    // MARK: - Outlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Setup
    
    func setup(with summaryViewModel: SummaryViewModel) {
        thumbnailImageView.backgroundColor = .clear
        nameLabel.text = summaryViewModel.title
        descriptionLabel.text = summaryViewModel.description
        thumbnailImageView.kf.indicatorType = .activity
        if let url = summaryViewModel.thumbnailImageUrl {
            thumbnailImageView.kf.indicatorType = .activity
            thumbnailImageView.kf.setImage(with: url)
        } else {
            thumbnailImageView.backgroundColor = .darkGray
        }
    }
}
