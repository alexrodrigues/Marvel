//
//  FavoriteViewController.swift
//  Marvel
//
//  Created by Alex Rodrigues on 17/04/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import AVFoundation
import UIKit
import RxCocoa
import RxSwift

class FavoriteViewController: UIViewController {

    // MARK: - Variables
    
    private let favoriteCell = "FavoriteCell"
    private var disposeBag = DisposeBag()
    private var favoriteViewModel = FavoriteViewModel()
    private var charactersArray = [CharacterViewModel]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        favoriteViewModel.fetchFavorites()
    }
    
    // MARK: - RxBind
    
    private func bind() {
        favoriteViewModel.charactersFavorites
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (characters) in
                guard let self = self else { return }
                if (characters.isEmpty) {
                    self.favoriteLabel.isHidden = false
                    self.activityIndicator.stopAnimating()
                    return
                }
                self.charactersArray.append(contentsOf: characters)
                self.setupCollectionview()
            }).disposed(by: disposeBag)
        
        favoriteViewModel.errorMessage
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (message) in
                if (message.isEmpty) { return }
                guard let self = self else { return }
                self.showErrorAlert(message)
            }).disposed(by: disposeBag)
    }
    
    private func setupCollectionview() {
        activityIndicator.stopAnimating()
        favoriteCollectionView.isHidden = false
        favoriteCollectionView.reloadData()
    }
    
    private func registerCells() {
        favoriteCollectionView.register(UINib(nibName: favoriteCell, bundle: nil), forCellWithReuseIdentifier: favoriteCell)
    }
    
    private func showLoading() {
        favoriteCollectionView.isHidden = true
        activityIndicator.startAnimating()
        charactersArray.removeAll()
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteCell, for: indexPath) as? FavoriteCell else {
            return UICollectionViewCell()
        }
        
        let character =  charactersArray[indexPath.row]
        cell.setup(favorite: character)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let original = CGSize(width: 100.0, height: 160.0)
        let ratio = CGFloat(1.6)
        let width = UIScreen.main.bounds.size.width
        var totalPerLine = 2
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            totalPerLine = 4
        }
        
        let desiredWidth = (width / CGFloat(totalPerLine)) - 16.0
        
        let desired = CGRect(x: 0, y: 0, width: desiredWidth, height: desiredWidth * ratio)
        return AVMakeRect(aspectRatio: original, insideRect: desired).size
    }
}
