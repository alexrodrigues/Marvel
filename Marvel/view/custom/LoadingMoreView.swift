//
//  LoadingMoreView.swift
//  Marvel
//
//  Created by Alex Rodrigues on 25/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

class LoadingMoreView: UIView {

    static func loadFromNibNamed() -> UIView? {
        return UINib(
            nibName: "TempLoadingMore",
            bundle: Bundle.main
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
