//
//  FavoriteComponent.swift
//  Marvel
//
//  Created by Alex Rodrigues  on 27/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

class GradientView: UIView {

    @IBInspectable var startColor: UIColor = UIColor.white {
        didSet {
            gradientLayer.colors = [ startColor.cgColor, endColor.cgColor ]
        }
    }

    @IBInspectable var endColor: UIColor = UIColor.black {
        didSet {
            gradientLayer.colors = [ startColor.cgColor, endColor.cgColor ]
        }
    }

    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            gradientLayer.startPoint = startPoint
        }
    }

    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet {
            gradientLayer.endPoint = endPoint
        }
    }

    private var gradientLayer: CAGradientLayer = CAGradientLayer()

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private func setupLayer() {
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }

    override func layoutSubviews() {
        gradientLayer.frame = self.bounds
    }
}
