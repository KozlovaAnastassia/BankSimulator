//
//  LocalDataStore.swift
//  BankSimulator
//
//  Created by Анастасия on 25.09.2023.
//

import Foundation
import UIKit
import CoreData

protocol LocalDataServiceProtocol {
    func getContext() -> NSManagedObjectContext
    func saveDataToCoreData(withData data: [String], entityName: String, key: [String], completion: (NSManagedObject) -> ())
    func fetchDataFromCoreData(entityName: String) -> [NSManagedObject]?
    func coreDataEntityIsEmpty(entityName: String) -> Bool
    func deleteFromCoreData(entityName: String)
}

class LocalDataService: LocalDataServiceProtocol {
    
     func getContext() -> NSManagedObjectContext {
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         return appDelegate.persistentContainer.viewContext
     }
    
    func saveDataToCoreData(withData data: [String], entityName: String, key: [String], completion: (NSManagedObject) -> ()) {
        let context = getContext()
         
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {return}
        let taskObject = NSManagedObject(entity: entity, insertInto: context)
        let seq = zip(key, data)
        let dict = Dictionary(uniqueKeysWithValues: seq)
        
        for (key, value) in dict {
            taskObject.setValue(value, forKey: key)
        }
         
        do {
            try context.save()
            completion(taskObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func fetchDataFromCoreData(entityName: String) -> [NSManagedObject]? {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            let result = try context.fetch(fetchRequest)
            if let objects = result as? [NSManagedObject] {
                        return objects
                    }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func deleteFromCoreData(entityName: String) {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        }
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func coreDataEntityIsEmpty(entityName: String) -> Bool{
        let context =  getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

        do {
            let result = try context.fetch(fetchRequest)
            if result.isEmpty {
                print("data not exist")
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
