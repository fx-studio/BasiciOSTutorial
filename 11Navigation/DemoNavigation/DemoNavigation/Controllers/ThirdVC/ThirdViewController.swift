//
//  ThirdViewController.swift
//  DemoNavigation
//
//  Created by Le Phuong Tien on 11/11/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Third VC"
    }
    
    @IBAction func pop(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func popController(_ sender: Any) {
        let vc = (self.navigationController?.viewControllers[1])!
        self.navigationController?.popToViewController(vc, animated: true)
        
    }
    
    @IBAction func popRoot(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
