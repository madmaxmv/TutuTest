//
//  City+CoreDataProperties.swift
//  TutuTest
//
//  Created by Максим on 12.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension City {

    @NSManaged var directionType: String?
    @NSManaged var countryTitle: String?
    @NSManaged var districtTitle: String?
    @NSManaged var cityId: NSNumber?
    @NSManaged var cityTitle: String?
    @NSManaged var regionTitle: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var stations: NSOrderedSet?

}
