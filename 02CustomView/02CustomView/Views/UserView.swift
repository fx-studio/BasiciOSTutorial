//
//  UserView.swift
//  02CustomView
//
//  Created by Le Phuong Tien on 10/16/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

protocol UserViewDelegate {
    func didTap(view: UserView, count: Int)
}

class UserView: UIView {
    
    var count = 0
    var delegate: UserViewDelegate?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func tap(_ sender: Any) {
        count += 1
        nameLabel.text = "\(count)"
        
        if let delegate = delegate {
            delegate.didTap(view: self, count: count)
        }
    }
    
}
