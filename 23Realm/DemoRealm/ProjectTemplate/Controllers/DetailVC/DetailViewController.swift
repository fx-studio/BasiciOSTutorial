//
//  DetailViewController.swift
//  ProjectTemplate
//
//  Created by Le Phuong Tien on 1/2/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subTitleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    var isNew = false
    
    var book: Book?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Config
    override func setupUI() {
        
        title = isNew ? "New" : "Edit"
        
        let newItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = newItem
        
        deleteButton.isHidden = isNew
        titleTextField.isUserInteractionEnabled = isNew
    }
    
    override func setupData() {
        if let book = book {
            titleTextField.text = book.title
            subTitleTextField.text = book.subTitle
            priceTextField.text = "\(book.price)"
        }
    }
    
    //MARK: - Navigation
    @objc func done() {
        guard let title = titleTextField.text,
            let subTitle = subTitleTextField.text,
            let price = Int(priceTextField.text ?? "0") else { return }
        
        if isNew {
            //add new a item
            
            do {
                // realm
                let realm = try Realm()
                
                // book
                let book = Book()
                book.title = title
                book.subTitle = subTitle
                book.price = price
                
                // add to realm
                try realm.write {
                    realm.add(book)
                }
                
                self.navigationController?.popViewController(animated: true)
                
            } catch {
                print("Lỗi thêm đối tượng vào Realm")
            }
            
        } else {
            //edit item
            
            do {
                
                if let book = book {
                    // realm
                    let realm = try Realm()
                    
                    // edit book
                    try realm.write {
                        book.subTitle = subTitle
                        book.price = price
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
            } catch {
                print("Lỗi edit đối tượng")
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func deleteItem(_ sender: Any) {
        do {
            
            if let book = book {
                // realm
                let realm = try Realm()
                
                // edit book
                try realm.write {
                    realm.delete(book)
                }
                
                self.navigationController?.popViewController(animated: true)
            }
            
        } catch {
            print("Lỗi Delete đối tượng")
        }
    }
    
    //MARK: - Data
    
}
