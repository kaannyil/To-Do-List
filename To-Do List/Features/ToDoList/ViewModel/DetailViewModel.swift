//
//  DetailViewModel.swift
//  To-Do List
//
//  Created by Kaan Yıldırım on 16.08.2023.
//

import Foundation

final class DetailViewModel {
    
    var view: DetailViewController?
    
    func segueToBackView() {
        view?.navigationController?.popViewController(animated: true)
    }
}
