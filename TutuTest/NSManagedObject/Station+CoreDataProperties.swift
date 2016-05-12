//
//  Station+CoreDataProperties.swift
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

extension Station {

    @NSManaged var stationId: NSNumber?
    @NSManaged var stationTitle: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var city: City

}
