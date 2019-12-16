//
//  HomeViewController.swift
//  DemoTabbarController
//
//  Created by Le Phuong Tien on 12/6/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    
    var viewmodel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        fetchData()
    }
    
    func updateUI() {
        emailLabel.text = viewmodel.email
    }
    
    func fetchData() {
        viewmodel.fetchData { (done, email, password) in
            if done {
                self.updateUI()
            } else {
                print("LỖI")
            }
        }
    }
}
