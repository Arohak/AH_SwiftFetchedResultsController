//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Ara Hakobyan on 8/1/15.
//  Copyright (c) 2015 Ara Hakobyan. All rights reserved.
//

import UIKit
import CoreData

class UniversitiesViewController: BaseCoreDataTableViewController {
    
    var fetchedResults: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest(entityName: "University")
        let universities = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [University]
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = [sortDescriptor]
        
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
        
        DataManager.sharedHelper.addRandomUniversity()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let university = self.fetchedResultsController.objectAtIndexPath(indexPath) as! University
        let vc = StudentsViewController.new()
        vc.university = university
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        super.configureCell(cell, atIndexPath: indexPath)
        
        let university = self.fetchedResultsController.objectAtIndexPath(indexPath) as! University
        cell.textLabel!.text = university.name
    }
}

