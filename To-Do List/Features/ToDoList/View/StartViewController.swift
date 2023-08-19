//
//  StartViewController.swift
//  To-Do List
//
//  Created by Kaan Yıldırım on 14.08.2023.
//

import UIKit

final class StartViewController: UIViewController {
    
    private var newNoteButton: UIButton = UIButton()
    
    private var viewModel = StartViewModel()
    
    // MARK: - Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.layer.cornerRadius = 20
        
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
        viewModel.takeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(takeData),
                                               name: NSNotification.Name(rawValue: "dataEntered"),
                                               object: nil)
    }
    
    @objc func takeData() {
        viewModel.takeData()
        tableView.reloadData()
    }
    
    func drawDesing() {
        // UI Elementlerinde (renk gibi) değişiklik yapılma ihtimali varsa,
        // bunu DispatchQueue da yapmak daha sağlıklı bir sonuç verir.
        DispatchQueue.main.async {
            self.title = "To-Do List"
            
            self.view.backgroundColor = .systemBackground
            
            self.newNoteButton.backgroundColor = .systemBlue
            self.newNoteButton.setTitle("+", for: .normal)
            self.newNoteButton.setTitleColor(.systemBackground, for: .normal)
            let fontSize = min(self.newNoteButton.frame.width,
                               self.newNoteButton.frame.height) * 0.5
            self.newNoteButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            self.newNoteButton.layer.cornerRadius = 20
            self.newNoteButton.layer.shadowColor = UIColor.black.cgColor
            self.newNoteButton.layer.shadowOpacity = 0.5
            self.newNoteButton.layer.shadowOffset = CGSize(width: 4, height: 4)
            self.newNoteButton.layer.shadowRadius = 4
            self.newNoteButton.addTarget(self, action: #selector(self.buttonClicked),
                                         for: .touchUpInside)
        }
    }
    
    func configure() {
        view.addSubview(newNoteButton)
        view.addSubview(tableView)
        
        // Buttonu ön planda tutmak için yazılan kod
        view.bringSubviewToFront(newNoteButton)
    
        setTableViewDelegates()
        tableView.rowHeight = 75
        tableView.register(StartTableViewCell.self, forCellReuseIdentifier: StartTableViewCell.identifier)
        
        // Set Constraints
        // makeTableView()
        // tableView.pin(to: view)
        
        UIProperties()
    }
}

// MARK: - Delegates
extension StartViewController {
    private func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Button Controller
extension StartViewController {
    
    @objc func buttonClicked() {
        viewModel.segueToDetailView()
    }
}

// MARK: - Programmatically UI Design
extension StartViewController {
    
    private func makeTableView() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.bottom.equalTo(view.snp.bottom).offset(-10)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-10)
        }
    }
    
    private func makeNewNoteButton() {
        newNoteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-30)
            make.width.equalTo(80)
            make.height.greaterThanOrEqualTo(80)
        }
    }
    
    func UIProperties() {
        makeNewNoteButton()
        makeTableView()
    }
}

// MARK: - TableView Delegates
extension StartViewController: UITableViewDelegate, UITableViewDataSource {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewModel.prepare(for: segue, sender: Any?.self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StartTableViewCell.identifier,
                                                       for: indexPath) as? StartTableViewCell else {
            return UITableViewCell()
        }
        
        let data = viewModel.arr
        cell.set(start: data, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath)
    }
}
