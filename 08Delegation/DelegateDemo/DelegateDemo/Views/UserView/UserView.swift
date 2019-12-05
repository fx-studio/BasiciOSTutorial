//
//  UserView.swift
//  DelegateDemo
//
//  Created by Le Phuong Tien on 10/25/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

protocol UserViewDelegate: class {
    func userView(userView: UserView, didSelectedWith index: Int)
}

protocol UserViewDataSource: class {
    func userView(nameOf userView: UserView) -> String
    func userView(indexOf userView: UserView) -> Int
}

class UserView: UIView {
    
    weak var dataSource: UserViewDataSource?
    weak var delegate: UserViewDelegate?
    var index: Int = 0
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func tap(_ sender: Any) {
        if let delegate = delegate {
            delegate.userView(userView: self, didSelectedWith: index)
        }
    }
    
    func configView() {
        if let dataSource = dataSource {
            //set index
            index = dataSource.userView(indexOf: self)
            
            //set name
            nameLabel.text = dataSource.userView(nameOf: self)
        }
    }
    
}
