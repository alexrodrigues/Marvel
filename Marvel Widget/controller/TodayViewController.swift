//
//  TodayViewController.swift
//  Marvel Widget
//
//  Created by Alex Rodrigues on 21/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - Variables
    
    private var viewModel: TodayViewModel!
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    // MARK: - Actions
    
    @IBAction func open() {
        guard let url = URL(string: "marvelapp://") else { return }
        self.extensionContext?.open(url, completionHandler: { (success) in
            if (!success) {
                print("error: failed to open app from Today Extension")
            }
        })
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TodayViewModel()
        fetch()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 150)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: - Data
    
    private func fetch() {
        viewModel.fetch { [weak self] (viewModels, errorMessage) in
            guard let self = self else { return }
            if !errorMessage.isEmpty {
                self.buttonsStackView.isHidden = true
                self.errorMessageLabel.isHidden = false
                self.errorMessageLabel.text = errorMessage
                return
            }
            
            if viewModels.count != 3 {
                self.buttonsStackView.isHidden = true
                self.errorMessageLabel.isHidden = false
                self.errorMessageLabel.text = "Something went wrong"
                return
            }
            
            self.activityIndicatorView.stopAnimating()
            
            self.buttonsStackView.isHidden = false
            self.errorMessageLabel.isHidden = true
            
            self.firstButton.setTitle(viewModels.first?.name, for: .normal)
            self.secondButton.setTitle(viewModels[1].name, for: .normal)
            self.thirdButton.setTitle(viewModels[2].name, for: .normal)
        }
    }
}
