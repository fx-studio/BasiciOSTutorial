//
//  BaseViewController.swift
//  PracticeTemplate
//
//  Created by Tien Le P. on 6/22/18.
//  Copyright © 2018 Tien Le P. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : setup Data & UI
    func setupData() {
    }
    
    func setupUI() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back",
                                                                style: .plain,
                                                                target: nil,
                                                                action: nil)
    }

}
