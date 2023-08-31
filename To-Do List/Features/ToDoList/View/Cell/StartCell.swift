//
//  StartTableViewCell.swift
//  To-Do List
//
//  Created by Kaan Yıldırım on 15.08.2023.
//

import UIKit

class StartCell: UITableViewCell {
    static let identifier = "StartTableCell"
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var checkButton = UIButton()
    
    var isChecked = false
    
    var defaultTitleLabelColor = UIColor()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        defaultTitleLabelColor = titleLabel.textColor
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        contentView.addSubview(checkButton)
        
        changeCheckButtonImage(bool: isChecked)
        
        drawDesign()
        UIProperties()
    }
    
    private func drawDesign() {
        titleLabel.numberOfLines = 1
        // titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.layer.masksToBounds = true

        subTitleLabel.textColor = .systemGray2
        subTitleLabel.numberOfLines = 1
        subTitleLabel.font = .systemFont(ofSize: 17)
        subTitleLabel.layer.masksToBounds = true
        
        // checkButton.backgroundColor = .red
        checkButton.layer.borderWidth = 3
        checkButton.layer.borderColor = UIColor.systemGray2.cgColor
        checkButton.layer.cornerRadius = 3
        checkButton.tintColor = .systemBlue
        checkButton.addTarget(self, action: #selector(checkControl), for: .touchUpInside)
       
    }
}

// MARK: - ChangeButtonImage
extension StartCell {
    func changeCheckButtonImage(bool: Bool) {
        if bool == true {
            isChecked = bool
            checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            
            let attributedText = NSMutableAttributedString(string: titleLabel.text ?? "Error")
            let range = NSRange(location: 0, length: attributedText.length)
            attributedText.addAttribute(.strikethroughStyle, value: 1, range: range)
            
            titleLabel.attributedText = attributedText
            titleLabel.textColor = .systemGray2
            
        } else {
            isChecked = bool
            checkButton.setImage(UIImage(systemName: ""), for: .normal)
            
            let attributedText = NSMutableAttributedString(string: titleLabel.text ?? "Error")
            let range = NSRange(location: 0, length: attributedText.length)
            attributedText.removeAttribute(.strikethroughStyle, range: range)
            
            titleLabel.attributedText = attributedText
            titleLabel.textColor = .label
            
        }
    }
}

// MARK: - ButtonClicked
extension StartCell {
    @objc func checkControl() {
        
        if isChecked == false {
            changeCheckButtonImage(bool: true)
            
            print("Check Button is true")
        } else {
            changeCheckButtonImage(bool: false)
            
            print("Check Button is false")
        }
    }
}

// MARK: - Constraints
extension StartCell {
    private func makeTitleLabel() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(checkButton.snp.trailing).offset(10)
            make.bottom.equalTo(subTitleLabel.snp.top)
            make.trailing.equalToSuperview().offset(-5)
        }
    }
    
    private func makeSubTitleLabel() {
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    private func makeCheckButton() {
        checkButton.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.leading.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            
        }
    }

    func UIProperties() {
        makeTitleLabel()
        makeSubTitleLabel()
        makeCheckButton()
    }
    
}

// MARK: - Page Features
extension StartCell {
    func set(start: Start, _ indexPath: IndexPath) {
        titleLabel.text = start.description[indexPath.row]
        
        subTitleLabel.text = start.date[indexPath.row] + " // " +
        start.time[indexPath.row]
        
        
    }
}
