//
//  Photo+CoreDataProperties.swift
//  Diplom
//
//  Created by Mac on 07.01.2023.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var profile: Profile?

}

extension Photo : Identifiable {

}
