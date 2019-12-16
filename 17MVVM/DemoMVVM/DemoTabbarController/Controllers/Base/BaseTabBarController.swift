//
//  BaseTabBarController.swift
//  DemoMVVM
//
//  Created by Tien Le P. on 7/12/18.
//  Copyright © 2018 Tien Le P. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor(red: 95.0/255.0, green: 75.0/255.0, blue: 139.0/255.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
