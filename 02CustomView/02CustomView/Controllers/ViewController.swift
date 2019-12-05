//
//  ViewController.swift
//  02CustomView
//
//  Created by Le Phuong Tien on 10/16/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hamster = MyView(frame: CGRect(x: 50, y: 100, width: 100, height: 125))
        hamster.nameLabel?.text = "hamster"
        hamster.avatarImageView?.image = UIImage(named: "hamster")
        view.addSubview(hamster)
        
        let husky = MyView(frame: CGRect(x: 200, y: 100, width: 100, height: 125))
        husky.nameLabel?.text = "husky"
        husky.avatarImageView?.image = UIImage(named: "husky")
        view.addSubview(husky)
        
        
        let userView = Bundle.main.loadNibNamed("UserView", owner: self, options: nil)?.first as? UserView
        userView?.frame = CGRect(x: 50, y: 250, width: 100, height: 125)
        userView?.delegate = self
        view.addSubview(userView!)
    }


}

extension ViewController: UserViewDelegate {
    func didTap(view: UserView, count: Int) {
        print("Count = \(count)")
    }
}

