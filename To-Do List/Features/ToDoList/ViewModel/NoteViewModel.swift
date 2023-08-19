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
    var view: StartViewController?
    
    var chooseID: UUID?
    var chooseDescription = ""
 
    func viewDidLoad() {
        view?.drawDesing()
        view?.configure()
    }
    
    func segueToDetailView() {
        let vc = DetailViewController()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func takeData() {
        arr.description.removeAll(keepingCapacity: false)
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
                        print(arr.description.count)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        arr.id.append(id)
                        print(arr.description.count)
                    }
                }
            }
        } catch {
            print("There is an Error !")
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return arr.description.count
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        
        destinationVC.chooseDescription = chooseDescription
        destinationVC.chooseUUID = chooseID!
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        chooseDescription = arr.description[indexPath.row]
        chooseID = arr.id[indexPath.row]
        
        segueToDetailView()
    }
}
