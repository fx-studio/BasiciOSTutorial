//
//  DetailViewController.swift
//  DelegateDemo
//
//  Created by Le Phuong Tien on 10/25/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func didChangedName(with name: String)
}

class DetailViewController: UIViewController {
    
    weak var delegate: DetailViewControllerDelegate?

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: Any) {
        if let delegate = delegate {
            delegate.didChangedName(with: nameTextField.text ?? "unknown")
        }
    }
    
    
}
