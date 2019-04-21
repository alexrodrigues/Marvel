//
//  UIView+Accessibility.swift
//  Marvel
//
//  Created by Alex Rodrigues on 30/12/18.
//  Copyright © 2018 Alex Rodrigues. All rights reserved.
//

import UIKit

extension UIView {
    func receiveAccessibilityIdentifier(identifier: AccessibilityIdentifiers) {
        self.accessibilityLabel = identifier.rawValue
        self.accessibilityIdentifier = identifier.rawValue
    }
}

extension UIBarButtonItem {
    func receiveAccessibilityIdentifier(identifier: AccessibilityIdentifiers) {
        self.accessibilityIdentifier = identifier.rawValue
    }
}
