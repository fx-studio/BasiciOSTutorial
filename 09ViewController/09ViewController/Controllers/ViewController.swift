//
//  ViewController.swift
//  09ViewController
//
//  Created by Le Phuong Tien on 11/5/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("🔵 viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("🔵 viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("🔵 viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("🔵 viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("🔵 viewDidDisappear")
    }
    

}

