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
import Kingfisher

class DetailViewController: UIViewController {

    // MARK: - Variables
    
    private var disposeBag = DisposeBag()
    private var favoriteBarButton: UIBarButtonItem!
    private let summaryCellIdentifier = "SummaryCell"
    var character: CharacterViewModel!
    private var detailViewModel: DetailViewModel!
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activtiyIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var detailTableView: UITableView!
    
    // MARK: - Coordinator auxiliars
    
    static func instantiateFromStoryboard(character: CharacterViewModel) -> DetailViewController {
        guard let detail = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            fatalError("Could not find a ViewController of type \(String(describing: type(of: self)))")
        }
        detail.character = character
        return detail
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailViewModel = DetailViewModel()
        setupView()
        bind()
        registerCells()
        detailViewModel.fetch(character: character)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Setup
    
    private func setupView() {
        navigationItem.title = character.name
        setupFavoriteButton()
        nameLabel.text = character.name
        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: character.profileImageUrl)
    }
    
    // MARK: - View Model Binding
    
    private func bind() {
        detailViewModel
            .comicsArray
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentTableview()
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        detailViewModel
            .eventsArray
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentTableview()
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        detailViewModel
            .storiesArray
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentTableview()
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        detailViewModel
            .seriesArray
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentTableview()
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Presentation
    
    private func registerCells() {
        detailTableView.register(UINib(nibName: summaryCellIdentifier, bundle: nil), forCellReuseIdentifier: summaryCellIdentifier)
    }
    
    private func presentTableview () {
        self.activtiyIndicatorView.stopAnimating()
        self.detailTableView.reloadData()
    }
    
    private func getRightArray(section: Int) -> [SummaryViewModel] {
        if section == 0 {
            return detailViewModel.comicsArray.value
        } else if section == 1 {
            return detailViewModel.eventsArray.value
        } else if section == 2 {
            return detailViewModel.storiesArray.value
        }
        return detailViewModel.seriesArray.value
    }
    
    private func setupFavoriteButton() {
        detailViewModel.isFavorite(character: character)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] exists in
                guard let self = self else { return }
                if exists {
                    self.favoriteBarButton = UIBarButtonItem(title: "Unfavorite", style: .done, target: self, action: #selector(DetailViewController.unfavorite))
                    self.navigationItem.rightBarButtonItem = self.favoriteBarButton
                } else {
                    self.favoriteBarButton = UIBarButtonItem(title: "Favorite", style: .done, target: self, action: #selector(DetailViewController.favorite))
                    self.navigationItem.rightBarButtonItem = self.favoriteBarButton
                }
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Favorite Methods
    
    @objc func favorite() {
        detailViewModel.insert(character: character)
            .subscribe(onNext: { _ in
                self.setupFavoriteButton()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    @objc func unfavorite() {
        detailViewModel.delete(character: character)
            .subscribe(onNext: { _ in
                self.setupFavoriteButton()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate Methods

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: summaryCellIdentifier, for: indexPath) as? SummaryCell else {
            return UITableViewCell()
        }
        let summaryViewModel = getRightArray(section: indexPath.section)[indexPath.row]
        cell.setup(with: summaryViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRightArray(section: section).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return detailViewModel.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91.0
    }
}
