//
//  UIView+Extensions.swift
//  Marvel
//
//  Created by Alex Rodrigues on 27/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult func topAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func bottomAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func leadingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func trailingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func heightAnchor(equalTo height: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult func widthAnchor(equalTo height: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult func centerXAnchor(equalTo anchor: NSLayoutXAxisAnchor) -> Self {
        centerXAnchor.constraint(equalTo: anchor).isActive = true
        return self
    }
    
    @discardableResult func centerYAnchor(equalTo anchor: NSLayoutYAxisAnchor) -> Self {
        centerYAnchor.constraint(equalTo: anchor).isActive = true
        return self
    }
}
