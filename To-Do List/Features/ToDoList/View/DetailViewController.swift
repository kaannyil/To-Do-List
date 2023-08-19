//
//  DetailViewController.swift
//  To-Do List
//
//  Created by Kaan Yıldırım on 15.08.2023.
//

import UIKit
import CoreData

final class DetailViewController: UIViewController {
    
    private var descriptionTextField: UITextField = UITextField()
    private var dateTextField: UITextField = UITextField()
    private var timeTextField: UITextField = UITextField()
    private var saveButton: UIButton = UIButton()
    
    var viewModel = DetailViewModel()
    
    var chooseDescription = ""
    var chooseUUID = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        drawDesing()
        configure()
        
        if chooseDescription != "" {
            // Core Datadan bilgi alınacak.
            
            
        } else {
            saveButton.isHidden = false
            // saveButton.isEnabled = false
            descriptionTextField.text = ""
            dateTextField.text = ""
            timeTextField.text = ""
        }
        
        gestureRecgnizeFeature()
    }
    
    func drawDesing() {
        DispatchQueue.main.async {
            self.title = "To-Do Page"
            
            self.view.backgroundColor = .systemBackground
            
            self.descriptionTextField.placeholder = "Description"
            self.descriptionTextField.borderStyle = .roundedRect
            
            self.descriptionTextField.layer.shadowColor = UIColor.systemGray.cgColor
            self.descriptionTextField.layer.shadowOpacity = 0.5
            self.descriptionTextField.layer.shadowOffset = CGSize(width: 1,
                                                                  height: 1)
            self.descriptionTextField.layer.shadowRadius = 2
            
            self.dateTextField.placeholder = "DD.MM.YYYY"
            self.dateTextField.borderStyle = .roundedRect
            self.dateTextField.layer.shadowColor = UIColor.systemGray.cgColor
            self.dateTextField.layer.shadowOpacity = 0.5
            self.dateTextField.layer.shadowOffset = CGSize(width: 1, height: 1)
            self.dateTextField.layer.shadowRadius = 2
            
            self.timeTextField.placeholder = "HH.MM"
            self.timeTextField.borderStyle = .roundedRect
            self.timeTextField.layer.shadowColor = UIColor.systemGray.cgColor
            self.timeTextField.layer.shadowOpacity = 0.5
            self.timeTextField.layer.shadowOffset = CGSize(width: 1, height: 1)
            self.timeTextField.layer.shadowRadius = 2
            
            self.saveButton.backgroundColor = .systemBlue
            self.saveButton.layer.cornerRadius = 10
            self.saveButton.setTitle("Save", for: .normal)
            self.saveButton.setTitleColor(.systemBackground, for: .normal)
            self.saveButton.layer.shadowColor = UIColor.systemGray.cgColor
            self.saveButton.layer.shadowOpacity = 0.5
            self.saveButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.saveButton.layer.shadowRadius = 2
            self.saveButton.addTarget(self, action: #selector(self.saveButtonClicked), for: .touchUpInside)
        }
    }
    
    func configure() {
        view.addSubview(descriptionTextField)
        view.addSubview(dateTextField)
        view.addSubview(timeTextField)
        view.addSubview(saveButton)
        
        makeDescriptionTextField()
        makeDateTextField()
        makeTimeTextField()
        makeSaveButton()
    }

}

// MARK: - Page Features
extension DetailViewController {
    func gestureRecgnizeFeature() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Button
extension DetailViewController {
    @objc func saveButtonClicked() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let toDoList = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
        
        toDoList.setValue(descriptionTextField.text, forKey: "explanation")
        toDoList.setValue(dateTextField.text, forKey: "date")
        toDoList.setValue(timeTextField.text, forKey: "time")
        toDoList.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("You saved.")
        } catch {
            print("You have an Error !")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("dataEntered"), object: nil)
        viewModel.segueToBackView()
    }
}

// MARK: - Programmatically UI Design
extension DetailViewController {
    
    func makeDescriptionTextField() {
        descriptionTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(-90)
            // make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.width.equalTo(280)
            make.height.equalTo(40)
        }
    }
    
    func makeDateTextField() {
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(20)
            make.leading.equalTo(descriptionTextField.snp.leading)
            make.trailing.equalTo(descriptionTextField.snp.trailing)
            make.height.equalTo(descriptionTextField.snp.height)
        }
    }
    
    func makeTimeTextField() {
        timeTextField.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(20)
            make.leading.equalTo(descriptionTextField.snp.leading)
            make.trailing.equalTo(descriptionTextField.snp.trailing)
            make.height.equalTo(descriptionTextField.snp.height)
        }
    }
    
    func makeSaveButton() {
        saveButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(timeTextField.snp.bottom).offset(20)
            make.width.equalTo(75)
            make.height.equalTo(descriptionTextField.snp.height)
        }
    }
}


