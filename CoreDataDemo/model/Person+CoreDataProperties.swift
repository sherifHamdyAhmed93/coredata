//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Sherif Hamdy on 11/10/2022.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int64
    @NSManaged public var gender: Bool

}

extension Person : Identifiable {

}
