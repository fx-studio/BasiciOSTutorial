//
//  HomeViewController.swift
//  09ViewController
//
//  Created by Le Phuong Tien on 11/5/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        
        self.view = view
    }
}
