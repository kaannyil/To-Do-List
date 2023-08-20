//
//  DetailViewModel.swift
//  To-Do List
//
//  Created by Kaan Yıldırım on 16.08.2023.
//

import UIKit
import CoreData

final class DetailViewModel {
    
    var view: DetailViewController?
    
    func segueToBackView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func viewDidLoad() {
        view?.configure()
        view?.drawDesing()
        view?.gestureRecgnizeFeature()
    }
    
    func fetchData() {
        print(view?.chooseDetailDescription ?? "Fetch Description Error !")
        
        if view?.chooseDetailUUID?.uuidString != nil {
            // Core Datadan bilgi alınacak.
            view?.saveButton.isHidden = true
            
            if let uuidString = view?.chooseDetailUUID?.uuidString {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let results = try context.fetch(fetchRequest)
                    // MARK: - CHANGE IT !
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            if let description = result.value(forKey: "explanation") as? String {
                                view?.descriptionTextField.text = description
                            }
                            
                            if let date = result.value(forKey: "date") as? String {
                                view?.dateTextField.text = date
                            }
                            
                            if let time = result.value(forKey: "time") as? String {
                                view?.timeTextField.text = time
                            }
                        }
                    }
                } catch {
                    print("There is an Error !")
                }
            }
        } else {
            view?.saveButton.isHidden = false
            // saveButton.isEnabled = false
            view?.descriptionTextField.text = ""
            view?.dateTextField.text = ""
            view?.timeTextField.text = ""
        }
    }
    
    func saveButton() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let toDoList = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
        
        toDoList.setValue(view?.descriptionTextField.text, forKey: "explanation")
        toDoList.setValue(view?.dateTextField.text, forKey: "date")
        toDoList.setValue(view?.timeTextField.text, forKey: "time")
        toDoList.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("You saved.")
        } catch {
            print("You have an Error !")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("dataEntered"),
                                        object: nil)
        
        segueToBackView()
    }
    
}
