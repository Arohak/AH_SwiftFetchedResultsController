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

@objc(University)
class University: NSManagedObject {
    
    @NSManaged var name : String
    @NSManaged var students : NSSet
    
}