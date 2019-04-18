//
//  Favorite+CoreDataProperties.swift
//  
//
//  Created by Digital on 27/03/19.
//
//

import Foundation
import CoreData

extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageExtension: String?
    @NSManaged public var path: String?
    @NSManaged public var id: Int32

}
