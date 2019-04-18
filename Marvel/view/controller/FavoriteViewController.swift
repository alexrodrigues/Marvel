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
    
    private let homeCell = "HomeListCell"
    private var disposeBag = DisposeBag()
    private var favoriteViewModel = FavoriteViewModel()
    private var charactersArray = [CharacterViewModel]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        registerCells()
        favoriteViewModel.fetchFavorites()
    }
    
    // MARK: - RxBind
    
    private func bind() {
        favoriteViewModel.charactersFavorites
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (characters) in
                if (characters.isEmpty) { return }
                guard let self = self else { return }
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
        favoriteCollectionView.register(UINib(nibName: homeCell, bundle: nil), forCellWithReuseIdentifier: homeCell)
    }
    
    private func showLoading() {
        favoriteCollectionView.isHidden = true
        activityIndicator.startAnimating()
        charactersArray.removeAll()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.detailFavorite {
            if let character = sender as? CharacterViewModel, let destination = segue.destination as? DetailViewController {
                destination.character = character
            }
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
