//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Ara Hakobyan on 8/1/15.
//  Copyright (c) 2015 Ara Hakobyan. All rights reserved.
//

import UIKit
import CoreData

class StudentsViewController: BaseCoreDataTableViewController {
    
    var university : University!
    
    var fetchedResults: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Student")
        let students = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Student]
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "university == %@", self.university)
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
        
        let student = DataManager.sharedHelper.addRandomStudent()
        student.university = self.university
        
        DataManager.sharedHelper.saveContext()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Student
        let vc = CarsViewController.new()
        vc.student = student
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        super.configureCell(cell, atIndexPath: indexPath)

        let student = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Student
        cell.textLabel!.text = student.firstName
        cell.detailTextLabel!.text = "\(student.score)"
    }
}

