//
//  DetailViewModel.swift
//  To-Do List
//
//  Created by Kaan Yıldırım on 16.08.2023.
//

import UIKit
import CoreData

final class DetailViewModel {
    
    var view: DetailView?
    
    func segueToBackView() {
        // Go to Previous Page
        view?.navigationController?.popViewController(animated: true)
    }
    
    func viewDidLoad() {
        view?.configure()
        view?.drawDesing()
        view?.gestureRecognizeFeature()
        view?.notificationSetup() 
    }
}

// MARK: - Core Data Operations
extension DetailViewModel {
    func saveButton() {
        
        guard let userInput = view?.descriptionTextField.text else {
            return // Metin alınamadıysa işlemi durdur
        }
        
        // Metni boşluk karakterleri temizleyerek kontrol ediyoruz.
        let trimmedText = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            descriptionFieldEmpty()
        } else {
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
    
    func fetchData() {
        print(view?.chooseDetailDescription ?? "Fetch Description Error !")
        
        if view?.chooseDetailUUID?.uuidString != nil {
            // Core Datadan bilgi alınacak.
            view?.saveButton.isHidden = true
            view?.editButton.isHidden = false
           
            
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
            view?.editButton.isHidden = true
            // saveButton.isEnabled = false
            view?.descriptionTextField.text = ""
            view?.dateTextField.text = ""
            view?.timeTextField.text = ""
        }
    }
    
    func editButton() {
        guard let userInput = view?.descriptionTextField.text else {
            return // Metin alınamadıysa işlemi durdur
        }
        
        // Metni boşluk karakterleri temizleyerek kontrol ediyoruz.
        let trimmedText = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            descriptionFieldEmpty()
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            if let uuidString = view?.chooseDetailUUID?.uuidString {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                   let results = try context.fetch(fetchRequest)
                   
                   if results.count > 0 {
                       if let result = results.first as? NSManagedObject {
                           // Güncellemeleri burada yapabilirsiniz.
                           result.setValue(view?.descriptionTextField.text, forKey: "explanation")
                           result.setValue(view?.dateTextField.text, forKey: "date")
                           result.setValue(view?.timeTextField.text, forKey: "time")
                           
                           do {
                               try context.save() // Güncellemeleri kaydet
                               print("Veri güncellendi.")
                           } catch {
                               print("Veri güncelleme hatası: \(error)")
                           }
                       }
                   }
                } catch {
                   print("Veri çekme hatası: \(error)")
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("dataEntered"),
                                                object: nil)
                
                segueToBackView()
            }
        }
    }
}

// MARK: - Functions
extension DetailViewModel {
    private func descriptionFieldEmpty() {
        let ac = UIAlertController(title: "Description Field Empty !", message: "Please write something on Description Text Field.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.view?.present(ac, animated: true)
    }
}
