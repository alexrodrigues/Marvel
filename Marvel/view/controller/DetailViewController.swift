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
    @IBOutlet weak var detailTableView: UITableView!
    
    private var disposeBag = DisposeBag()
    private let SUMMARY_CELL_IDENTIFIER = "SummaryCell"
    
    let sectionTitles = ["Comics", "Events", "Stories", "Series"]
    var comicsArray = [SummaryViewModel]()
    var eventsArray = [SummaryViewModel]()
    var storiesArray = [SummaryViewModel]()
    var seriesArray = [SummaryViewModel]()
    
    var character: CharacterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetch()
        CharactersService().insert(character: character)
            .subscribe(onNext: { success in
                
            }, onError: { error in
                
            }).disposed(by: disposeBag)
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
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewModels in
                guard let self = self else { return }
                self.comicsArray = viewModels
                self.presentTableview()
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        SummaryService()
            .fetch(models: character.eventsUris)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewModels in
                guard let self = self else { return }
                self.eventsArray = viewModels
                self.presentTableview()
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        SummaryService()
            .fetch(models: character.storiesUris)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewModels in
                guard let self = self else { return }
                self.storiesArray = viewModels
                self.presentTableview()
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        SummaryService()
            .fetch(models: character.seriesUris)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewModels in
                guard let self = self else { return }
                self.seriesArray = viewModels
                self.presentTableview()
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    private func presentTableview () {
        self.activtiyIndicatorView.stopAnimating()
        self.detailTableView.reloadData()
    }
    
    private func getRightArray(section: Int) -> [SummaryViewModel] {
        if section == 0 {
            return comicsArray
        } else if section == 1 {
            return eventsArray
        } else if section == 2{
            return storiesArray
        }
        return seriesArray
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SUMMARY_CELL_IDENTIFIER, for: indexPath)
        let summary = getRightArray(section: indexPath.section)[indexPath.row]
        cell.textLabel?.text = summary.title
        cell.detailTextLabel?.text = summary.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRightArray(section: section).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}

