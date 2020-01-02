//
//  HomeViewModel.swift
//  ProjectTemplate
//
//  Created by Le Phuong Tien on 12/20/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import Foundation
import RealmSwift

protocol HomeViewModelDelegate: class {
    func viewModel(_ viewModel: HomeViewModel, needperfomAction action: HomeViewModel.Action)
}

final class HomeViewModel {
    private var books: [Book] = []
    
    enum Action {
        case reloadData
    }

    private var notificationToken: NotificationToken?
    weak var delegate: HomeViewModelDelegate?
    
    //Data
    
    func setupObserve() {
        let realm = try! Realm()
        notificationToken = realm.objects(Book.self).observe({ (change) in
            self.delegate?.viewModel(self, needperfomAction: .reloadData)
        })
    }
    
    func fetchData(completion: (Bool) -> ()) {
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(Book.self)
            
            // convert to array
            books = Array(results)
            
            // call back
            completion(true)
            
        } catch {
            // call back
            completion(false)
        }
    }
    
    func deleteAll(completion: (Bool) -> ()) {
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(Book.self)
            
            // delete all items
            try realm.write {
                realm.delete(results)
            }
            
            // call back
            completion(true)
            
        } catch {
            // call back
            completion(false)
        }
    }
    
    // TableView
    func numberBooks() -> Int {
        books.count
    }
    
    func getBook(at indexPath: IndexPath) -> Book {
        return books[indexPath.row]
    }
}
