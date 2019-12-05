//
//  ViewController.swift
//  02TouchEvent
//
//  Created by Le Phuong Tien on 10/15/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var blueView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            if touch.view == redView {
                print("inside RedView")
            } else if touch.view == blueView {
                print("inside BlueView")
            } else {
                print("outside RedView")
            }
//            let currentPointOfView = touch.location(in: view)
//            print("View point(\(currentPointOfView.x), \(currentPointOfView.y))")
//
//            let currentPointOfRedView = touch.location(in: redView)
//            print("RedView point(\(currentPointOfRedView.x), \(currentPointOfRedView.y))")

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

}

