//
//  User+CoreDataProperties.swift
//  DemoCoreData
//
//  Created by Le Phuong Tien on 12/21/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var gender: Bool
    @NSManaged public var name: String?

}
