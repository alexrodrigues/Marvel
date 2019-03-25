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
    
    private let HOME_CELL = "HomeListCell"
    private let FIRST_PAGE = 1
    private var disponseBag = DisposeBag()
    private lazy var service = CharactersService()
    private var charactersArray = [CharacterViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        fetch(page: FIRST_PAGE)
    }
    
    private func registerCells() {
        listTableView.register(UINib(nibName: HOME_CELL, bundle: nil), forCellReuseIdentifier: HOME_CELL)
    }

    private func fetch(page: Int) {
        CharactersService().fetch()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.charactersArray = response
                self.activityIndicator.stopAnimating()
                self.listTableView.isHidden = false
                self.listTableView.reloadData()
            }, onError: { (error) in
                self.showErrorAlert(error.localizedDescription)
            }).disposed(by: disponseBag)
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
}


