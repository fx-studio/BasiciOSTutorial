//
//  BalllViewController.swift
//  02TouchEvent
//
//  Created by Le Phuong Tien on 10/15/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class BalllViewController: UIViewController {

    @IBOutlet weak var ball: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == ball {
                let location = touch.location(in: view)
                ball.center = location
            }
        }
    }

}
