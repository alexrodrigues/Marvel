//
//  FavoriteService.swift
//  Marvel
//
//  Created by Digital on 27/03/19.
//  Copyright © 2019 Alex Rodrigues. All rights reserved.
//

import UIKit
import CoreData
import RxCocoa
import RxSwift

class FavoriteRepository {
    
    func insert(character: CharacterViewModel) -> Observable<Bool> {
        let context = getCoreDataContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: context) else {
            return Observable.just(false)
        }
        let favorite = NSManagedObject(entity: entity, insertInto: context)
        favorite.setValue(character.name, forKey: "name")
        favorite.setValue(character.identifier, forKey: "id")
        favorite.setValue(character.path, forKey: "path")
        favorite.setValue(character.imageExtension, forKey: "imageExtension")
        do {
            try context.save()
        } catch {
            return Observable.just(false)
        }
        return Observable.just(true)
    }
    
    func delete(character: CharacterViewModel) -> Observable<Bool> {
        let context = getCoreDataContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for obj in result as! [NSManagedObject] {
                if let identifier = obj.value(forKey: "id") as? Int, identifier == character.identifier {
                    context.delete(obj)
                }
            }
            try context.save()
        } catch {
            return Observable.just(false)
        }
        return Observable.just(true)
    }
    
    func fetch() -> Observable<[CharacterViewModel]> {
        let context = getCoreDataContext()
        var viewModels = [CharacterViewModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                var character = MarvelCharacter()
                character.thumbnail = CharacterThumbnail()
                if let name = data.value(forKey: "name") as? String {
                    character.name = name
                }
                if let identifier = data.value(forKey: "id") as? Int {
                    character.id = identifier
                }
                if let path = data.value(forKey: "path") as? String {
                    character.thumbnail?.path = path
                }
                if let imageExtension = data.value(forKey: "imageExtension") as? String {
                    character.thumbnail?.imageExtension = imageExtension
                }
                viewModels.append(CharacterViewModel(character: character))
            }
        } catch {
            return Observable.error(MyError(msg: "Failed fetching"))
        }
        
        return Observable.just(viewModels)
    }
    
    func find(character: CharacterViewModel) -> Observable<[CharacterViewModel]> {
        return Observable.create({ (observer) -> Disposable in
            
            let research = self.fetch()
                .subscribe(onNext: { (viewModels) in
                    let filtered = viewModels.filter { $0.identifier ==  character.identifier }
                    observer.onNext(filtered)
                    observer.onCompleted()
                }, onError: { _ in
                    observer.onError(MyError(msg: "Failed finding character \(character.name)"))
                })
            
            return Disposables.create {
                research.dispose()
            }
        })
    }
    
    private func getCoreDataContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
