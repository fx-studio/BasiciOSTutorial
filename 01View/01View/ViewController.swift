//
//  ViewController.swift
//  01View
//
//  Created by Le Phuong Tien on 10/14/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var titleLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set title
        titleLabel.text = "Fx Studio"
        
        for index in 0..<titleLabels.count {
            titleLabels[index].text = "Title Label \(index)"
        }
        
        // add user avatar
        let frame = CGRect(x: 50, y: 100, width: 100, height: 100)
        let userAvatar = UIImageView(image: UIImage(named: "no_avatar"))
        userAvatar.frame = frame
        userAvatar.contentMode = .scaleToFill
        view.addSubview(userAvatar)
        
        // add user name
        let userName = UILabel(frame: CGRect(x: 50, y: 200, width: 100, height: 25))
        userName.text = "Fx Studio"
        userName.backgroundColor = .lightGray
        userName.textAlignment = .center
        userName.textColor = .blue
        view.addSubview(userName)
        
        // add button
        let button = UIButton(frame: CGRect(x: 50, y: 100, width: 100, height: 225))
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        view.addSubview(button)
        
    }


    @objc func tap() {
        print("tap tap tap")
    }
    @IBAction func tapMe(_ sender: Any) {
        print("Tap meeeeeeeeeeee!")
    }
    
}

