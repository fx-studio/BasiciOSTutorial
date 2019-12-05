//
//  LineViewController.swift
//  02TouchEvent
//
//  Created by Le Phuong Tien on 10/15/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class LineViewController: UIViewController {
    
    var path = UIBezierPath()
    var firstLocation = CGPoint.zero
    var shapeLayer = CAShapeLayer()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        view.layer.addSublayer(shapeLayer)
        self.shapeLayer.lineWidth = 2
        self.shapeLayer.strokeColor = UIColor.blue.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: view){
            firstLocation = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: view) {
            
            path.removeAllPoints()
            path.move(to: firstLocation)
            path.addLine(to: location)

            shapeLayer.path = path.cgPath
        }
    }
}
