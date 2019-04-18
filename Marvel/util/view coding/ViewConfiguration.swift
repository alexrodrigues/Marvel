//
//  ViewConfiguration.swift
//  Marvel
//
//  Created by Alex Rodrigues on 13/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

protocol ViewConfiguration: class {
    func setupViews()
    func configureViews()
    func setupViewHierarchy()
    func setupConstraints()
}

extension ViewConfiguration {
    func setupViews() {
        configureViews()
        setupViewHierarchy()
        setupConstraints()
    }
    
    func configureViews() {}
    func setupViewHierarchy() {}
    func setupConstraints() {}
}
