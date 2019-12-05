//
//  DetailViewController.swift
//  DemoTableView
//
//  Created by Le Phuong Tien on 11/18/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        
        nameLabel.text = name
    }
}
