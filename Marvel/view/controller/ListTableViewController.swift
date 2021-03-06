//
//  ListTableViewController.swift
//  Marvel
//
//  Created by Alex Rodrigues on 20/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ListTableViewController: UITableViewController {

    // MARK: - Variables
    
    private let homeCell = "HomeTableCell"
    private let firstPage = 1
    private var lastKnowIndex = 1
    private var isLoadingRemoved = false
    private var disponseBag = DisposeBag()
    private var listViewModel: ListViewModel!
    private var charactersArray = [CharacterViewModel]()
    private var upperRefreshControl: UIRefreshControl!
    private var shouldLoadFirst = true
    private lazy var loadingMoreView: LoadingMoreView = {
        return LoadingMoreView.loadFromNibNamed() as! LoadingMoreView
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var listSearchBar: UISearchBar!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIdentifiersForUiTests()
        shouldLoadFirst = true
        bind()
        configureViews()
        fetch(page: firstPage)
    }
    
    // MARK: - ViewModel Binding
    
    private func bind() {
        if let split = splitViewController {
            listViewModel = ListViewModel(with: split)
        }
        listViewModel.characters
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (characters) in
                if (characters.isEmpty) { return }
                guard let self = self else { return }
                self.charactersArray.append(contentsOf: characters)
                self.setupTableview()
                self.hideRefreshers()
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
                self.listViewModel.presentiPadError(with: message)
            }).disposed(by: disponseBag)
    }
    
    // MARK: - Setup
    
    private func registerCells() {
        homeTableView.register(UINib(nibName: homeCell, bundle: nil), forCellReuseIdentifier: homeCell)
    }
    
    private func setupTableview() {
        homeTableView.reloadData()
        if let first = charactersArray.first, shouldLoadFirst {
            shouldLoadFirst = false
            listViewModel.navigateToiPadDetail(with: first)
        }
    }

    private func showLoading() {
        charactersArray.removeAll()
        listViewModel.presentiPadLoading()
    }
    
    private func hideRefreshers() {
        upperRefreshControl.endRefreshing()
    }
    
    private func setupLoadingMoreView() {
        upperRefreshControl = UIRefreshControl()
        upperRefreshControl.tintColor = .red
        upperRefreshControl.addTarget(self, action: #selector(ListViewController.performRefresh), for: .valueChanged)
        homeTableView.refreshControl = upperRefreshControl
        
        isLoadingRemoved = false
        loadingMoreView.frame = CGRect(x: 0, y: 0, width: homeTableView.frame.width, height: 50.0)
        homeTableView.tableFooterView = loadingMoreView
    }
    
    @objc func performRefresh() {
        fetch(page: firstPage)
    }
    
    @objc func performLoadMoreBottom() {
        fetch(page: charactersArray.count + 1)
    }
    
    private func disableLoadingMore() {
        upperRefreshControl.endRefreshing()
        homeTableView.bottomRefreshControl = nil
        homeTableView.refreshControl = nil
        
        isLoadingRemoved = true
        loadingMoreView.isHidden = true
    }
    
    func configureViews() {
        registerCells()
        setupLoadingMoreView()
        if let search = listSearchBar.value(forKey: "_searchField") as? UITextField {
            search.clearButtonMode = .never
        }
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
        setupLoadingMoreView()
        fetch(page: firstPage)
    }
    
    // MARK: - Identifiers for UI Tests
    
    private func setupIdentifiersForUiTests() {
        homeTableView.receiveAccessibilityIdentifier(identifier: .homeTableView)
        tabBarController?.tabBar.receiveAccessibilityIdentifier(identifier: .marvelTabbar)
    }
}

// MARK: - UITableViewDataSource & Delegate Methods

extension ListTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: homeCell, for: indexPath) as? HomeTableCell else {
            return UITableViewCell()
        }
        
        let character =  charactersArray[indexPath.row]
        cell.setup(with: character)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == charactersArray.count - 1 && !isLoadingRemoved {
            fetch(page: charactersArray.count + 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let aCharacter = charactersArray[indexPath.row]
        listViewModel.navigateToiPadDetail(with: aCharacter)
    }
    
}

// MARK: - UISearchBarDelegate Methods

extension ListTableViewController: UISearchBarDelegate {
    
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
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
