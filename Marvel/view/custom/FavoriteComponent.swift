//
//  FavoriteComponent.swift
//  Marvel
//
//  Created by Digital on 27/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol FavoriteComponentDelegate: class {
    func inflateFavorites()
    func disinflateFavorites()
}

class FavoriteComponent: UIView {
    
    
    private lazy var favoriteLabel: UILabel = {
       let label = UILabel(frame: .zero)
        label.textColor = UIColor.darkGray
        label.text = "Favorites"
        return label
    }()
    
    private lazy var favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 82.0, height: 90.0)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private weak var _delegate: FavoriteComponentDelegate?
    private var favoritesArray = [CharacterViewModel]()
    private let disposeBag = DisposeBag()
    private let FAVORITE_CELL = "FavoriteCell"

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        addSubview(favoriteLabel)
        addSubview(favoriteCollectionView)
        
        favoriteLabel
            .topAnchor(equalTo: topAnchor, constant: 0.0)
        
        
        favoriteCollectionView
            .leadingAnchor(equalTo: leadingAnchor, constant: 0.0)
            .trailingAnchor(equalTo: trailingAnchor, constant: 0.0)
            .topAnchor(equalTo: topAnchor, constant: 0.0)
            .bottomAnchor(equalTo: bottomAnchor, constant: 0.0)
    }
    
    func setup(delegate: FavoriteComponentDelegate) {
        registerCell()
        favoriteCollectionView.dataSource = self
        _delegate = delegate
        checkFavorites()
    }
    
    func checkFavorites() {
        CharactersService().fetchFavorites()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewModels in
                guard let self = self else { return }
                if viewModels.isEmpty {
                    self._delegate?.disinflateFavorites()
                } else {
                    self.favoritesArray = viewModels
                    self._delegate?.inflateFavorites()
                    self.registerCell()
                    self.favoriteCollectionView.reloadData()
                }
                }, onError: { [weak self] error in
                    guard let self = self else { return }
                    print(error.localizedDescription)
                    self._delegate?.disinflateFavorites()
            }).disposed(by: disposeBag)
    }
    
    private func registerCell() {
        favoriteCollectionView.register(UINib(nibName: FAVORITE_CELL, bundle: Bundle.main), forCellWithReuseIdentifier: FAVORITE_CELL)
    }
}

extension FavoriteComponent: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FAVORITE_CELL, for: indexPath) as? FavoriteCell else {
            return UICollectionViewCell()
        }
        let favorite = favoritesArray[indexPath.row]
        cell.setup(favorite: favorite, index: indexPath.row)
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 82.0, height: 90.0)
    }
}

