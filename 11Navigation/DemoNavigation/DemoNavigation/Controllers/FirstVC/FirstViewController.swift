//
//  FirstViewController.swift
//  DemoNavigation
//
//  Created by Le Phuong Tien on 11/11/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "First VC"
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        let leftButton1 = UIBarButtonItem(title: "Left 1", style: .plain, target: self, action: #selector(leftAction))
         let leftButton2 = UIBarButtonItem(title: "Left 2", style: .plain, target: self, action: #selector(leftAction))
        navigationItem.leftBarButtonItems = [leftButton1, leftButton2]
        
        let rightButton1 = UIBarButtonItem(title: "Right 1", style: .plain, target: self, action: #selector(rightAction))
         let rightButton2 = UIBarButtonItem(title: "Right 2", style: .plain, target: self, action: #selector(rightAction))
        navigationItem.rightBarButtonItems = [rightButton1, rightButton2]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("view Will Disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("view Did Disappear")
    }
    
    
    @IBAction func push(_ sender: Any) {
        let vc = SecondViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func leftAction() {
        print("taped")
    }
    
    @objc func rightAction() {
        print("taped")
    }
    
}
