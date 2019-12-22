//
//  NewViewController.swift
//  DemoCoreData
//
//  Created by Le Phuong Tien on 12/21/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit
import CoreData

class NewViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    //MARK: - Config
    func setupUI() {
        title = "New"
        
        //navigation bar
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    func setupData() {
        
    }
    
    //MARK: - Navigation Bar
    @objc func done() {
        // lấy AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // lấy Managed Object Context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // lấy Entity name
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        
        // tạo 1 Managed Object --> insert
        let user = User(entity: entity, insertInto: managedContext)
        
        // set giá trị cho Object
        user.name = nameTextField.text
        user.age = Int16(ageTextField.text!) ?? 0
        user.gender = genderSegmentedControl.selectedSegmentIndex == 0 ? true : false
        
        //save context
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
}
