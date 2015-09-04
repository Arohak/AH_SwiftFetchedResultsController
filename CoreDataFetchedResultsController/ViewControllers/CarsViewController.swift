//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Ara Hakobyan on 8/1/15.
//  Copyright (c) 2015 Ara Hakobyan. All rights reserved.
//

import UIKit
import CoreData

class CarsViewController: BaseCoreDataTableViewController {
    
    var student : Student!

    var fetchedResults: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Car")
        let cars = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Car]
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "model", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "student == %@", self.student)
        fetchRequest.predicate = predicate
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.fetchedResultsController = self.fetchedResults
    }
    
    override func insertNewObject(sender: AnyObject) {
        
        let car = DataManager.sharedHelper.addRandomCar()
        car.student = self.student
        
        DataManager.sharedHelper.saveContext()
    }

    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let car = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Car
        cell.textLabel!.text = car.model
    }
}

