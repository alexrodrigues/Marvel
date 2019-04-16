//
//  ListViewController.swift
//  Marvel
//
//  Created by Alex Rodrigues on 23/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ListViewController: UIViewController, ViewConfiguration {

    // MARK: - Variables
    
    private lazy var loadingMoreView: LoadingMoreView = {
        return LoadingMoreView.loadFromNibNamed() as! LoadingMoreView
    }()
    private let HOME_CELL = "HomeListCell"
    private let FIRST_PAGE = 1
    private var lastKnowIndex = 1
    private var isLoadingRemoved = false
    private var disponseBag = DisposeBag()
    private var listViewModel = ListViewModel()
    private var charactersArray = [CharacterViewModel]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var listSearchBar: UISearchBar!
    private lazy var favoriteComponent: FavoriteComponent = {
        return FavoriteComponent()
    }()
    private lazy var favoriteComponentHeight: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: favoriteComponent, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0.0, constant: 0.0)
        return constraint
    } ()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        favoriteComponent.setup(delegate: self)
        setupViews()
        fetch(page: FIRST_PAGE)
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
                self.setupTableview()
            }).disposed(by: disponseBag)
        
        listViewModel.searchCharacters
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (characters) in
                if (characters.isEmpty) { return }
                guard let self = self else { return }
                self.charactersArray = characters
                self.setupTableview()
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
        listTableView.register(UINib(nibName: HOME_CELL, bundle: nil), forCellReuseIdentifier: HOME_CELL)
    }
    
    private func setupTableview() {
        self.activityIndicator.stopAnimating()
        self.listTableView.isHidden = false
        self.listTableView.reloadData()
    }
    
    private func showLoading() {
        listTableView.isHidden = true
        activityIndicator.startAnimating()
        charactersArray.removeAll()
    }
    
    // MARK: - Setup View Methods
    
    private func setupLoadingMoreView() {
        isLoadingRemoved = false
        loadingMoreView.frame = CGRect(x: 0, y: 0, width: listTableView.frame.width, height: 50.0)
        listTableView.tableFooterView = loadingMoreView
    }
    
    private func disableLoadingMore() {
        isLoadingRemoved = true
        loadingMoreView.isHidden = true
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
        loadingMoreView.isHidden = false
        fetch(page: lastKnowIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.detail {
            if let character = sender as? CharacterViewModel, let destination = segue.destination as? DetailViewController {
                destination.character = character
            }
        }
    }
}

// MARK: - TableViewDelegate & TableViewDataSource Methods

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HOME_CELL, for: indexPath) as? HomeListCell else {
            return UITableViewCell()
        }
        cell.setup(character: charactersArray[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == charactersArray.count - 1 && !isLoadingRemoved {
            fetch(page: charactersArray.count + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: SegueIdentifiers.detail, sender: charactersArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Heroes"
        }
        return ""
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
        favoriteComponentHeight.constant = FavoriteComponent.OPEN_HEIGHT
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

