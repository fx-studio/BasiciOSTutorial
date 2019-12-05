//
//  SecondViewController.swift
//  DemoNavigation
//
//  Created by Le Phuong Tien on 11/11/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Second VC"
        
        let searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(tap))
        let bookMarkItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(tap))
        
        let settingItem = UIBarButtonItem(image: UIImage(named: "setting-icon"), style: .plain, target: self, action: #selector(tap))
        
        navigationItem.rightBarButtonItems = [searchItem, bookMarkItem, settingItem]
    }

    @IBAction func push(_ sender: Any) {
        let vc = ThirdViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pop(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tap() {
        print("taped")
    }
    
}
