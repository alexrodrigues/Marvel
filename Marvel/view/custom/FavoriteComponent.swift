//
//  FavoriteComponent.swift
//  Marvel
//
//  Created by Alex Rodrigues on 27/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol FavoriteComponentDelegate: class {
    func inflateFavorites()
    func disinflateFavorites()
}

class FavoriteComponent: UIView, ViewConfiguration {
    
    // MARK: - Variables
    
    private weak var _delegate: FavoriteComponentDelegate?
    private var favoritesArray = [CharacterViewModel]()
    private let disposeBag = DisposeBag()
    private let favoriteCell = "FavoriteCell"
    static let openHeight = CGFloat(150.0)
    
    private lazy var favoriteLabel: UILabel = {
       let label = UILabel(frame: .zero)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Favorites"
        return label
    }()
    
    private lazy var favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 82.0, height: 120.0)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
     // MARK: - Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func registerCell() {
        favoriteCollectionView.register(UINib(nibName: favoriteCell, bundle: Bundle.main), forCellWithReuseIdentifier: favoriteCell)
    }
    
    private func initialize() {
        setupViews()
    }
    
    func setup(delegate: FavoriteComponentDelegate) {
        registerCell()
        _delegate = delegate
        checkFavorites()
    }
    
    // MARK: - View Coding methods
    
    func configureViews() {
        favoriteCollectionView.dataSource = self
    }
    
    func setupViewHierarchy() {
        addSubview(favoriteLabel)
        addSubview(favoriteCollectionView)
    }
    
    func setupConstraints() {
        favoriteLabel
            .topAnchor(equalTo: topAnchor, constant: 16.0)
            .leadingAnchor(equalTo: leadingAnchor, constant: 16.0)
            .trailingAnchor(equalTo: trailingAnchor, constant: 16.0)
            .heightAnchor(equalTo: 21.0)
        
        favoriteCollectionView
            .leadingAnchor(equalTo: leadingAnchor, constant: 0.0)
            .trailingAnchor(equalTo: trailingAnchor, constant: 0.0)
            .topAnchor(equalTo: topAnchor, constant: 45.0)
            .bottomAnchor(equalTo: bottomAnchor, constant: 16.0)
    }
    
    // MARK: - Favorite methods
    
    func checkFavorites() {
        FavoriteRepository().fetch()
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
}

// MARK: - FavoriteComponent 

extension FavoriteComponent: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteCell, for: indexPath) as? FavoriteCell else {
            return UICollectionViewCell()
        }
        let favorite = favoritesArray[indexPath.row]
        cell.setup(favorite: favorite)
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesArray.count
    }
}
