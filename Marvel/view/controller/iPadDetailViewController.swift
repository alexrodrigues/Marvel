//
//  iPadDetailViewController.swift
//  Marvel
//
//  Created by Alex Rodrigues on 20/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class IPadDetailViewController: UIViewController {

    // MARK: - Variables
    
    private var disposeBag = DisposeBag()
    private let summaryCellIdentifier = "SummaryCell"
    private var character: CharacterViewModel?
    private var detailViewModel: DetailViewModel!
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activtiyIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Coordinator auxiliars
    
    static func instantiateFromStoryboard() -> IPadDetailViewController {
        guard let detail = UIStoryboard(name: "Main_iPad", bundle: nil).instantiateViewController(withIdentifier: "iPadDetailViewController") as? IPadDetailViewController else {
            fatalError("Could not find a ViewController of type \(String(describing: type(of: self)))")
        }
        return detail
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailViewModel = DetailViewModel()
        registerCells()
    }
    
    // MARK: - Presentation Logic
    
    func showLoading() {
        clearArrays()
        favoriteButton.setTitle("", for: .normal)
        detailTableView.isHidden = true
        activtiyIndicatorView.startAnimating()
    }
    
    func showError(with errorMessage: String) {
        if !errorMessage.isEmpty {
            errorMessageLabel.text = errorMessage
        }
        detailTableView.isHidden = true
        activtiyIndicatorView.stopAnimating()
        errorMessageLabel.isHidden = false
    }
    
    func start(with character: CharacterViewModel) {
        showLoading()
        self.character = character
        bind()
        setupView()
        activtiyIndicatorView.startAnimating()
        detailViewModel.fetch(character: character)
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
    
    // MARK: - Setup
    
    private func setupView() {
        navigationItem.title = character?.name
        setupFavoriteButton()
        nameLabel.text = character?.name
        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: character?.profileImageUrl)
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
        guard let characterViewModel = character else { return }
        detailViewModel.isFavorite(character: characterViewModel)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] exists in
                guard let self = self else { return }
                if exists {
                    self.favoriteButton.addTarget(self, action: #selector(IPadDetailViewController.unfavorite), for: .touchUpInside)
                    self.favoriteButton.setTitle("Unfavorite", for: .normal)
                } else {
                    self.favoriteButton.addTarget(self, action: #selector(IPadDetailViewController.favorite), for: .touchUpInside)
                    self.favoriteButton.setTitle("Favorite", for: .normal)
                }
            }).disposed(by: disposeBag)
    }
    
    private func presentTableview () {
        self.activtiyIndicatorView.stopAnimating()
        self.detailTableView.reloadData()
        self.detailTableView.isHidden = false
    }
    
    private func registerCells() {
        detailTableView.register(UINib(nibName: summaryCellIdentifier, bundle: nil), forCellReuseIdentifier: summaryCellIdentifier)
    }
    
    private func clearArrays() {
        detailViewModel.comicsArray.accept([SummaryViewModel]())
        detailViewModel.eventsArray.accept([SummaryViewModel]())
        detailViewModel.storiesArray.accept([SummaryViewModel]())
        detailViewModel.seriesArray.accept([SummaryViewModel]())
    }
    
    // MARK: - Favorite Methods
    
    @objc func favorite() {
        guard let characterViewModel = character else { return }
        detailViewModel.insert(character: characterViewModel)
            .subscribe(onNext: { _ in
                self.setupFavoriteButton()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    @objc func unfavorite() {
        guard let characterViewModel = character else { return }
        detailViewModel.delete(character: characterViewModel)
            .subscribe(onNext: { _ in
                self.setupFavoriteButton()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate Methods

extension IPadDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
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
