//
//  DetailViewController.swift
//  Marvel
//
//  Created by Alex Rodrigues on 26/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activtiyIndicatorView: UIActivityIndicatorView!
    
    private var disposeBag = DisposeBag()
    
    var character: CharacterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetch()
    }
    
    private func setupView() {
        self.navigationItem.title = character.name
        nameLabel.text = character.name
        ImageService.instance.downloadImage(url: character.profileImage, index: 0) { [weak self] (image, indexFromApi) in
            guard let self = self else { return }
            self.profileImageView.image = image
        }
    }
    
    private func fetch() {
        SummaryService()
            .fetch(models: character.comicsUris)
            .subscribe(onNext: { viewModels in
                print("Comics: \(viewModels.debugDescription)")
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        SummaryService()
            .fetch(models: character.eventsUris)
            .subscribe(onNext: { viewModels in
                print("Events: \(viewModels.debugDescription)")
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        SummaryService()
            .fetch(models: character.storiesUris)
            .subscribe(onNext: { viewModels in
                print("Stories: \(viewModels.debugDescription)")
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        SummaryService()
            .fetch(models: character.seriesUris)
            .subscribe(onNext: { viewModels in
                print("Series: \(viewModels.debugDescription)")
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
}
