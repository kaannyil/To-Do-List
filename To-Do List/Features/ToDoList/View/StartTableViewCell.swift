//
//  StartTableViewCell.swift
//  To-Do List
//
//  Created by Kaan Yıldırım on 15.08.2023.
//

import UIKit

class StartTableViewCell: UITableViewCell {
    static let identifier = "StartTableCell"
    
    var noteTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(noteTitleLabel)
        
        configureTitleLabel()
        makeTitleLabel()
    }
    
   private func configureTitleLabel() {
        noteTitleLabel.numberOfLines = 0
        noteTitleLabel.adjustsFontSizeToFitWidth = true
        noteTitleLabel.font = .systemFont(ofSize: 20)
        noteTitleLabel.layer.cornerRadius = 10
        noteTitleLabel.layer.masksToBounds = true
    }
}

// MARK: - Constraints
extension StartTableViewCell {
   private func makeTitleLabel() {
        noteTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(5)
            make.bottom.trailing.equalToSuperview().offset(-5)
        }
    }
}

// MARK: - Page Features
extension StartTableViewCell {
    func set(start: Start, _ indexPath: IndexPath) {
        noteTitleLabel.text = start.description[indexPath.row]
    }
}
