//
//  DataManager.swift
//  CoreDataTest
//
//  Created by Ara Hakobyan on 8/2/15.
//  Copyright (c) 2015 Ara Hakobyan. All rights reserved.
//

import CoreData

@objc(DataManager)
class DataManager: NSObject {
    
    var student1 : Student!
    var student2 : Student!
    
    let firstNameItems = ["Ara", "Karen", "Meri", "Gor", "Jora", "Davit", "Sasun", "Garnik", "Lipo", "Edo", "Samo", "Artur", "Aram"]
    let LastNameItems = ["Hakobyan", "Xrdilyan", "Aznavuryan", "Igityan", "Mesropyan", "Avetisyan", "Hovsepyan", "Nersisyan", "Xachatryan", "Atayan", "Xandanyan", "Elyazyan", "Naxikyan"]
    let carModels = ["Audi", "BMV", "Volvo", "Lada", "Mazda"]
    let universites = ["GMO", "ZARIA", "SKOLKOVO", "LENINA"]
    
    func generateObjects() {
        
//        for i in 0...5 {
//            self.addRandomStudent()
//            self.addRandomCar()
//        }
//
//        self.deleteOllObjects()
//
//        self.print("Student")
//        
//        self.addTwoObjects()
//        
//        self.deleteFirstStudent()
//        
//        self.addRandomUniversity()
        
//        self.deleteFirstUniversity()
        
        self.printOllObjects()
    }
    
    func getStudentTemplateForName() {
        
        let fetchRequest = self.managedModel?.fetchRequestTemplateForName("testFetchRequest")
        let students = self.managedObjectContext!.executeFetchRequest(fetchRequest!, error: nil) as! [Student]
        
        for student in students {
            NSLog("Student { \(student.firstName) - \(student.lastName) - \(student.dateOfBirth) - \(student.score) }\n")
        }
        
    }
    
    func addRandomStudent() -> (Student) {
        
        var student = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: self.managedObjectContext!) as! Student
        let firstName = self.firstNameItems[Int(arc4random_uniform(13))]
        let lastName = self.LastNameItems[Int(arc4random_uniform(13))]
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(60 * 60 * 24 * 365 * Int(arc4random_uniform(30))))
        let score = Double(arc4random_uniform(201)/100 + 3)
        student.firstName = firstName
        student.lastName = lastName
        student.dateOfBirth = date
        student.score = score
        
        return student
    }
    
    func addRandomCar() -> (Car) {
        
        var car = NSEntityDescription.insertNewObjectForEntityForName("Car", inManagedObjectContext: self.managedObjectContext!) as! Car
        let model = self.carModels[Int(arc4random_uniform(5))]
        car.model = model
        
        return car
    }
    
    func addTwoObjects() {
        
        student1 = self.addRandomStudent()
        student2 = self.addRandomStudent()
        
        let car1 = self.addRandomCar()
        let car2 = self.addRandomCar()
        
        student1.car = car1
        student2.car = car2
        
        self.saveContext()
    }
    
    func addRandomUniversity() {
        
        student1 = self.addRandomStudent()
        student2 = self.addRandomStudent()
        
        let car1 = self.addRandomCar()
        let car2 = self.addRandomCar()
        
        student1.car = car1
        student2.car = car2
        
        var university = NSEntityDescription.insertNewObjectForEntityForName("University", inManagedObjectContext: self.managedObjectContext!) as! University
        let name = self.universites[Int(arc4random_uniform(4))]
        university.name = name
        university.students = NSSet(objects: student1, student2)
        
        self.saveContext()
    }
    
    func deleteFirstStudent() {
        
        let request = NSFetchRequest(entityName: "Student")
        let students = self.managedObjectContext?.executeFetchRequest(request, error: nil) as! [Student]
        
        if students.count > 0 {
            self.managedObjectContext?.deleteObject(students.first!)
        }
        
        self.saveContext()
    }
    
    func deleteAllStudents() {
        
        let request = NSFetchRequest(entityName: "Student")
        let objects = self.managedObjectContext?.executeFetchRequest(request, error: nil) as! [Student]
        
        for student in objects {
            self.managedObjectContext?.deleteObject(student)
        }
        
        self.saveContext()
    }
    
    func deleteFirstUniversity() {
        
        let request = NSFetchRequest(entityName: "University")
        let university = self.managedObjectContext?.executeFetchRequest(request, error: nil) as! [University]
        
        if university.count > 0 {
            self.managedObjectContext?.deleteObject(university.first!)
        }
        
        self.saveContext()
    }
    
    func deleteOllObjects() {
        
        let request = NSFetchRequest(entityName: "ParentObject")
        let objects = self.managedObjectContext?.executeFetchRequest(request, error: nil) as! [NSManagedObject]
        
        for object in objects {
            self.managedObjectContext?.deleteObject(object)
        }
        
        self.saveContext()
    }
    
    func printOllObjects() {
        
        let request = NSFetchRequest(entityName: "ParentObject")
        let objects = self.managedObjectContext?.executeFetchRequest(request, error: nil) as! [NSManagedObject]
        
        for object in objects {
            if object.isMemberOfClass(Student) {
                let student = object as! Student
                NSLog("\(student.firstName) -- \(student.lastName) -- \(student.dateOfBirth) -- \(student.score)\n")
            } else if object.isMemberOfClass(Car){
                let car = object as! Car
                NSLog("\(car.student.firstName) -- \(car.model)\n")
            } else if object.isMemberOfClass(University){
                let university = object as! University
                NSLog("\n University { \(university.name) }\n")
                
                for student in university.students {
                    NSLog("Student { \(student.firstName) - \(student.lastName) - \(student.dateOfBirth) - \(student.score) } Car { \(student.car.model) }\n")
                }
            }
        }
    }
    
    func print(entity: String) {
        
        let request = NSFetchRequest(entityName: entity)
        let objects = self.managedObjectContext?.executeFetchRequest(request, error: nil) as! [Student]
        
        for student in objects {
            NSLog("\(student.firstName) -- \(student.lastName) -- \(student.dateOfBirth) -- \(student.score)\n")
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "AH.aa" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    //MARK: - Core Data stack
    
    //Managed Model
    lazy var managedModel: NSManagedObjectModel? = {
        var model: NSManagedObjectModel? = NSManagedObjectModel.mergedModelFromBundles(nil)
        return model
        }()
    
    //Store coordinator
    var _storeCoordinator: NSPersistentStoreCoordinator?
    var storeCoordinator: NSPersistentStoreCoordinator {
        if !(_storeCoordinator != nil){
            let _storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CSDataStorage.sqlite")
            _storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedModel!)
            
            func addStore() -> NSError?{
                var result: NSError? = nil
                if _storeCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: _storeURL, options: nil, error: &result) == nil{
                    println("Create persistent store error occurred: \(result?.userInfo)")
                }
                return result
            }
            
            var error = addStore()
            if  error != nil{
                println("Store scheme error. Will remove store and try again. TODO: add scheme migration.")
                NSFileManager.defaultManager().removeItemAtURL(_storeURL, error: nil)
                error = addStore()
                
                if (error != nil){
                    println("Unresolved critical error with persistent store: \(error?.userInfo)")
                    abort()
                }
            }
        }
        return _storeCoordinator!
    }
    
    //Managed Context
    lazy var managedObjectContext: NSManagedObjectContext? = {
        var context: NSManagedObjectContext? = NSManagedObjectContext()
        context?.persistentStoreCoordinator = self.storeCoordinator
        
        return context
        }()
    
    //Save context
    func saveContext() {
        println("Will save")
        var error: NSError? = nil
        var result: Bool = false
        let context = self.managedObjectContext
        if context != nil {
            if context!.hasChanges && !context!.save(&error){
                println("Save context error occurred: \(error?.userInfo)")
            }else{
                result = true
            }
        }
    }
    
    // MARK: - Singlton

    class var sharedHelper: DataManager {
        struct Static {
            static var instance: DataManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = DataManager()
        }
        
        return Static.instance!
    }
}
