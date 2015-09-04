//
//  File.swift
//  CoreDataTest
//
//  Created by Ara Hakobyan on 8/1/15.
//  Copyright (c) 2015 Ara Hakobyan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Car)
class Car: NSManagedObject {
    
    @NSManaged var model : String
    @NSManaged var student : Student
    
}