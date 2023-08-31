//
//  DetailViewController.swift
//  To-Do List
//
//  Created by Kaan Yıldırım on 15.08.2023.
//

import UIKit
import CoreData

final class DetailView: UIViewController {
    
    private let descriptionLabel: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()
    private let timeLabel: UILabel = UILabel()
    
    var descriptionTextField: UITextField = UITextField()
    var dateTextField: UITextField = UITextField()
    var timeTextField: UITextField = UITextField()
    var saveButton: UIButton = UIButton()
    var editButton: UIButton = UIButton()
    
    var viewModel = DetailViewModel()
    
    var chooseDetailDescription = ""
    var chooseDetailUUID: UUID?
    
    var isKeyboardOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
        viewModel.fetchData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
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
            
            self.descriptionLabel.text = "Description:"
            self.descriptionLabel.font = .boldSystemFont(ofSize: 18)
            self.descriptionLabel.sizeToFit()
            
            self.dateTextField.placeholder = "DD.MM.YYYY"
            self.dateTextField.borderStyle = .roundedRect
            self.dateTextField.layer.shadowColor = UIColor.systemGray.cgColor
            self.dateTextField.layer.shadowOpacity = 0.5
            self.dateTextField.layer.shadowOffset = CGSize(width: 1, height: 1)
            self.dateTextField.layer.shadowRadius = 2
            
            self.dateLabel.text = "Date:"
            self.dateLabel.font = .boldSystemFont(ofSize: 18)
            self.dateLabel.sizeToFit()
            
            self.timeTextField.placeholder = "HH:MM"
            self.timeTextField.borderStyle = .roundedRect
            self.timeTextField.layer.shadowColor = UIColor.systemGray.cgColor
            self.timeTextField.layer.shadowOpacity = 0.5
            self.timeTextField.layer.shadowOffset = CGSize(width: 1, height: 1)
            self.timeTextField.layer.shadowRadius = 2
            
            self.timeLabel.text = "Time:"
            self.timeLabel.font = .boldSystemFont(ofSize: 18)
            self.timeLabel.sizeToFit()
            
            self.saveButton.backgroundColor = .systemBlue
            self.saveButton.layer.cornerRadius = 10
            self.saveButton.setTitle("Save", for: .normal)
            self.saveButton.setTitleColor(.systemBackground, for: .normal)
            self.saveButton.layer.shadowColor = UIColor.systemGray.cgColor
            self.saveButton.layer.shadowOpacity = 0.5
            self.saveButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.saveButton.layer.shadowRadius = 2
            self.saveButton.addTarget(self, action: #selector(self.saveButtonClicked), for: .touchUpInside)
            
            self.editButton.backgroundColor = .systemBlue
            self.editButton.layer.cornerRadius = 10
            self.editButton.setTitle("Update", for: .normal)
            self.editButton.setTitleColor(.systemBackground, for: .normal)
            self.editButton.layer.shadowColor = UIColor.systemGray.cgColor
            self.editButton.layer.shadowOpacity = 0.5
            self.editButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.editButton.layer.shadowRadius = 2
            self.editButton.addTarget(self, action: #selector(self.editButtonClicked), for: .touchUpInside)
        }
    }
    
    func configure() {
        view.addSubview(descriptionTextField)
        view.addSubview(descriptionLabel)
        
        view.addSubview(dateTextField)
        view.addSubview(dateLabel)
        
        view.addSubview(timeTextField)
        view.addSubview(timeLabel)
        
        view.addSubview(saveButton)
        view.addSubview(editButton)
        
        makeDescriptionTextField()
        makeDescriptionLabel()
        
        makeDateTextField()
        makeDateLabel()
        
        makeTimeTextField()
        makeTimeLabel()
        
        makeSaveButton()
        makeEditButton()
    }

}

// MARK: - Page Features
extension DetailView {
    func gestureRecognizeFeature() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func notificationSetup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if isKeyboardOpen == false {
            isKeyboardOpen = true
            
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                let bottomSpace = self.view.frame.height - (saveButton.frame.origin.y + saveButton.frame.height)
                self.view.frame.origin.y -= keyboardHeight - bottomSpace + 30
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        isKeyboardOpen = false
        self.view.frame.origin.y = 0
    }
}

// MARK: - Button
extension DetailView {
    @objc func saveButtonClicked() {
        viewModel.saveButton()
    }
    
    @objc func editButtonClicked() {
        viewModel.editButton()
    }
}

// MARK: - Programmatically UI Design
extension DetailView {
    
    func makeDescriptionTextField() {
        descriptionTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(-100)
            // make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.width.equalTo(280)
            make.height.equalTo(40)
        }
    }
    
    func makeDescriptionLabel() {
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionTextField.snp.top)
            make.leading.equalTo(descriptionTextField.snp.leading)
        }
    }
    
    func makeDateTextField() {
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(30)
            make.leading.equalTo(descriptionTextField.snp.leading)
            make.trailing.equalTo(descriptionTextField.snp.trailing)
            make.height.equalTo(descriptionTextField.snp.height)
        }
    }
    
    func makeDateLabel() {
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(dateTextField.snp.top)
            make.leading.equalTo(dateTextField.snp.leading)
            
        }
    }
    
    func makeTimeTextField() {
        timeTextField.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(30)
            make.leading.equalTo(descriptionTextField.snp.leading)
            make.trailing.equalTo(descriptionTextField.snp.trailing)
            make.height.equalTo(descriptionTextField.snp.height)
        }
    }
    
    func makeTimeLabel() {
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(timeTextField.snp.top)
            make.leading.equalTo(timeTextField.snp.leading)
        }
    }
    
    func makeSaveButton() {
        saveButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(timeTextField.snp.bottom).offset(30)
            make.width.equalTo(75)
            make.height.equalTo(descriptionTextField.snp.height)
        }
    }
    
    func makeEditButton() {
        editButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(timeTextField.snp.bottom).offset(30)
            make.width.equalTo(75)
            make.height.equalTo(descriptionTextField.snp.height)
        }
    }
}


