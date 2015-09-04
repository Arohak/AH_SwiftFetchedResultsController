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

@objc(Student)
class Student: NSManagedObject {
    
    @NSManaged var firstName : String
    @NSManaged var lastName : String
    @NSManaged var dateOfBirth : NSDate
    @NSManaged var score : Double
    @NSManaged var car : Car
    @NSManaged var university : University
    
}