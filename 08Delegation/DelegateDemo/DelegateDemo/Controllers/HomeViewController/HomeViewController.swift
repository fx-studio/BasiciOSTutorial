//
//  HomeViewController.swift
//  DelegateDemo
//
//  Created by Le Phuong Tien on 10/25/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let userView = Bundle.main.loadNibNamed("UserView", owner: self, options: nil)?.first as! UserView
        userView.frame = CGRect(x: 50, y: 150, width: 100, height: 125)
        userView.index = 10
        userView.delegate = self
        userView.dataSource = self
        view.addSubview(userView)
        
        userView.configView()
    }
}


extension HomeViewController: UserViewDelegate {
    func userView(userView: UserView, didSelectedWith index: Int) {
        print("Did select UserView with index \(index)")
    }
}

extension HomeViewController: UserViewDataSource {
    func userView(nameOf userView: UserView) -> String {
        return "Fx Studio"
    }
    
    func userView(indexOf userView: UserView) -> Int {
        return 999
    }
}
