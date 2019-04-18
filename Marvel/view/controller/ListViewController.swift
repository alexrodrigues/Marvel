//
//  ListViewController.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import AVFoundation
import UIKit
import RxCocoa
import RxSwift

class ListViewController: UIViewController, ViewConfiguration {

    // MARK: - Variables
    
    private let homeCell = "HomeListCell"
    private let firstPage = 1
    private var lastKnowIndex = 1
    private var isLoadingRemoved = false
    private var disponseBag = DisposeBag()
    private var listViewModel = ListViewModel()
    private var charactersArray = [CharacterViewModel]()
    private var bottomRefreshControl: UIRefreshControl!
    private var upperRefreshControl: UIRefreshControl!
    private lazy var favoriteComponent: FavoriteComponent = {
        return FavoriteComponent()
    }()
    private lazy var favoriteComponentHeight: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: favoriteComponent, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0.0, constant: 0.0)
        return constraint
    } ()
    
    // MARK: - Outlets
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var listSearchBar: UISearchBar!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        favoriteComponent.setup(delegate: self)
        setupViews()
        fetch(page: firstPage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favoriteComponent.checkFavorites()
    }
    
    private func bind() {
        listViewModel.characters
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (characters) in
                if (characters.isEmpty) { return }
                guard let self = self else { return }
                self.charactersArray.append(contentsOf: characters)
                self.setupCollectionview()
                self.hideRefreshers()
            }).disposed(by: disponseBag)
        
        listViewModel.searchCharacters
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (characters) in
                if (characters.isEmpty) { return }
                guard let self = self else { return }
                self.charactersArray = characters
                self.setupCollectionview()
            }).disposed(by: disponseBag)
        
        listViewModel.errorMessage
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (message) in
                if (message.isEmpty) { return }
                guard let self = self else { return }
                self.showErrorAlert(message)
            }).disposed(by: disponseBag)
    }
    
    private func registerCells() {
        homeCollectionView.register(UINib(nibName: homeCell, bundle: nil), forCellWithReuseIdentifier: homeCell)
    }
    
    private func setupCollectionview() {
        activityIndicator.stopAnimating()
        homeCollectionView.isHidden = false
        homeCollectionView.reloadData()
    }
    
    private func showLoading() {
        homeCollectionView.isHidden = true
        activityIndicator.startAnimating()
        charactersArray.removeAll()
    }
    
    private func hideRefreshers() {
        bottomRefreshControl.endRefreshing()
        upperRefreshControl.endRefreshing()
    }
    
    // MARK: - Setup View Methods
    
    private func setupLoadingMoreView() {
        bottomRefreshControl = UIRefreshControl()
        bottomRefreshControl.tintColor = .red
        bottomRefreshControl.addTarget(self, action: #selector(ListViewController.performLoadMoreBottom), for: .valueChanged)
        homeCollectionView.bottomRefreshControl = bottomRefreshControl
        
        upperRefreshControl = UIRefreshControl()
        upperRefreshControl.tintColor = .red
        upperRefreshControl.addTarget(self, action: #selector(ListViewController.performRefresh), for: .valueChanged)
        homeCollectionView.refreshControl = upperRefreshControl
    }
    
    @objc func performRefresh() {
        fetch(page: firstPage)
    }
    
    @objc func performLoadMoreBottom() {
        fetch(page: charactersArray.count + 1)
    }
    
    private func disableLoadingMore() {
        upperRefreshControl.endRefreshing()
        bottomRefreshControl.endRefreshing()
        homeCollectionView.bottomRefreshControl = nil
        homeCollectionView.refreshControl = nil
    }
    
    // MARK: - View Coding Methods
    
    func configureViews() {
        registerCells()
        setupLoadingMoreView()
        if let search = listSearchBar.value(forKey: "_searchField") as? UITextField {
            search.clearButtonMode = .never
        }
    }
    
    func setupViewHierarchy() {
    }
    
    func setupConstraints() {
        favoriteComponent.addConstraint(favoriteComponentHeight)
    }
    
    // MARK: - ViewModel Fetch Methods
    
    private func fetch(page: Int) {
        lastKnowIndex = page
        listViewModel.fetch(lastIndex: lastKnowIndex)
    }
    
    // MARK: - Search Methods
    
    private func search(text: String) {
        listViewModel.search(text: text)
    }

    private func searchCancelled() {
        showLoading()
        isLoadingRemoved = false
        setupLoadingMoreView()
        fetch(page: firstPage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.detail {
            if let character = sender as? CharacterViewModel, let destination = segue.destination as? DetailViewController {
                destination.character = character
            }
        }
    }
}

// MARK: - CollectionViewDelegate & CollectionViewDataSource Methods

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCell, for: indexPath) as? HomeListCell else {
            return UICollectionViewCell()
        }
        
        let character =  charactersArray[indexPath.row]
        cell.setup(character: character)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.detail, sender: charactersArray[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HomeListCell {
            cell.didHighlight()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HomeListCell {
            cell.didUnHighlight()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let original = CGSize(width: 100.0, height: 160.0)
        let ratio = CGFloat(1.6)
        let width = UIScreen.main.bounds.size.width
        let desiredWidth = (width / 2) - 16.0
        
        let desired = CGRect(x: 0, y: 0, width: desiredWidth, height: desiredWidth * ratio)
        return AVMakeRect(aspectRatio: original, insideRect: desired).size
    }
}

// MARK: - UISearchBarDelegate Methods

extension ListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchBar.showsCancelButton = true
            showLoading()
            disableLoadingMore()
            search(text: searchText)
        } else {
            showErrorAlert("Please type the name of your hero")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchCancelled()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty) {
            searchBar.showsCancelButton = false
            searchBar.resignFirstResponder()
            searchCancelled()
        }
    }
}

// MARK: - FavoriteComponentDelegate Methods

extension ListViewController: FavoriteComponentDelegate {
    
    func inflateFavorites() {
        favoriteComponentHeight.constant = FavoriteComponent.openHeight
        UIView.animate(withDuration: 0.6) {
            self.view.setNeedsLayout()
        }
    }
    
    func disinflateFavorites() {
        favoriteComponentHeight.constant = 0.0
        UIView.animate(withDuration: 0.6) {
            self.view.setNeedsLayout()
        }
    }
}
