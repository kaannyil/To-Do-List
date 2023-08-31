//
//  StartViewModel.swift
//  To-Do List
//
//  Created by Kaan Yıldırım on 15.08.2023.
//

import Foundation
import UIKit
import CoreData

final class StartViewModel {
    
    var arr: Start = Start()
    var view: StartView?
    
    var chooseID: UUID?
    var chooseDescription = ""
    var chooseDate = ""
    var chooseTime = ""
 
    func viewDidLoad() {
        view?.drawDesing()
        view?.configure()
    }
    
    func segueToDetailView() {
        let vc = DetailView()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfRowsInSection() -> Int {
        return arr.description.count
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        let destinationVC = DetailView()
        
        chooseDescription = arr.description[indexPath.row]
        chooseID = arr.id[indexPath.row]
        
        prepareForDetailViewController(detailVC: destinationVC)
        
        view?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func prepareForDetailViewController(detailVC: DetailView) {
        detailVC.chooseDetailDescription = chooseDescription
        detailVC.chooseDetailUUID = chooseID!
    }
}

// MARK: - Core Data Operations
extension StartViewModel {
    func takeData() {
        arr.description.removeAll(keepingCapacity: false)
        arr.date.removeAll(keepingCapacity: false)
        arr.time.removeAll(keepingCapacity: false)
        arr.id.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let description = result.value(forKey: "explanation") as? String {
                        arr.description.append(description)
                    }
                    
                    if let date = result.value(forKey: "date") as? String {
                        arr.date.append(date)
                    }
                    
                    if let time = result.value(forKey: "time") as? String {
                        arr.time.append(time)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        arr.id.append(id)
                    }
                }
            }
        } catch {
            print("There is an Error !")
        }
    }
    
    func deleteData(_ indexpath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        let uuidString = arr.id[indexpath.row].uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do {
            let results = try context.fetch(fetchRequest)
            // MARK: - CHANGE IT
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let id = result.value(forKey: "id") as? UUID {
                        if id == arr.id[indexpath.row] {
                            context.delete(result)
                            
                            print("Your note '\(arr.description[indexpath.row])' has been deleted.")
                            
                            arr.id.remove(at: indexpath.row)
                            arr.description.remove(at: indexpath.row)
                            
                            do {
                                try context.save()
                            } catch {
                                print("There is an Error !")
                            }
                            break
                        }
                    }
                }
            }
        } catch {
            
        }
    }
}
