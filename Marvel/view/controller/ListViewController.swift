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

class ListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var listSearchBar: UISearchBar!
    @IBOutlet weak var favoriteComponent: FavoriteComponent!
    @IBOutlet weak var favoriteComponentHeight: NSLayoutConstraint!
    
    private lazy var loadingMoreView: LoadingMoreView = {
        return LoadingMoreView.loadFromNibNamed() as! LoadingMoreView
    }()
    
    private let HOME_CELL = "HomeListCell"
    private let FIRST_PAGE = 1
    private var lastKnowIndex = 1
    private var isLoadingRemoved = false
    private var disponseBag = DisposeBag()
    private lazy var service = CharactersService()
    private var charactersArray = [CharacterViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteComponent.setup(delegate: self)
        setupView()
        fetch(page: FIRST_PAGE)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favoriteComponent.checkFavorites()
    }
    
    private func registerCells() {
        listTableView.register(UINib(nibName: HOME_CELL, bundle: nil), forCellReuseIdentifier: HOME_CELL)
    }

    private func search(text: String) {
        CharactersService().search(text: text)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.charactersArray = response
                self.setupTableview()
                }, onError: { (error) in
                    self.showErrorAlert(error.localizedDescription)
            }).disposed(by: disponseBag)
    }
    
    private func fetch(page: Int) {
        lastKnowIndex = page
        CharactersService().fetch(lastIndex: page)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.charactersArray.append(contentsOf: response)
                self.setupTableview()
            }, onError: { (error) in
                self.showErrorAlert(error.localizedDescription)
            }).disposed(by: disponseBag)
    }
    
    private func setupView() {
        registerCells()
        setupLoadingMoreView()
        if let search = listSearchBar.value(forKey: "_searchField") as? UITextField {
            search.clearButtonMode = .never
        }
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
    
    private func setupLoadingMoreView() {
        isLoadingRemoved = false
        loadingMoreView.frame = CGRect(x: 0, y: 0, width: listTableView.frame.width, height: 50.0)
        listTableView.tableFooterView = loadingMoreView
    }
    
    private func disableLoadingMore() {
        isLoadingRemoved = true
        loadingMoreView.isHidden = true
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
        return 68.0
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
}

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

extension ListViewController: FavoriteComponentDelegate {
    
    func inflateFavorites() {
        favoriteComponentHeight.constant = 90.0
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

