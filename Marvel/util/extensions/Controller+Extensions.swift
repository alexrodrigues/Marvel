//
//  Controller+Extensions.swift
//  Marvel
//
//  Created by Alex Rodrigues on 27/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
        }))
        present(alert, animated: true) {
        }
    }
}
