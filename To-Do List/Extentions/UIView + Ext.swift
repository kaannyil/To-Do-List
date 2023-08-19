//
//  UIView + Ext.swift
//  To-Do List
//
//  Created by Kaan Yıldırım on 15.08.2023.
//

import UIKit

extension UIView {
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints                               = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive             = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive       = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive     = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive   = true
        
    }
}
