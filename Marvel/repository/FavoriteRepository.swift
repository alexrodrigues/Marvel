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

    func save(character: CharacterViewModel) -> Observable<Bool> {
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
    
    func fetch() -> Observable<[CharacterViewModel]> {
        let context = getCoreDataContext()
        var viewModels = [CharacterViewModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                var character = Character()
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
    
    private func getCoreDataContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
