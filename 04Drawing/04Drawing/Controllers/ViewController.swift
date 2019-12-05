//
//  ViewController.swift
//  04Drawing
//
//  Created by Le Phuong Tien on 10/17/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        drawLine(start: CGPoint(x: 50, y: 100), end: CGPoint(x: 350, y: 600))
            
//        let lineView = FxLineView(frame: view.bounds)
//        lineView.drawLine(start: CGPoint(x: 50, y: 100), end: CGPoint(x: 300, y: 600))
//        view.addSubview(lineView)
        
        let rectView = FxRectangularView(frame: CGRect(x: 30, y: 300, width: 350, height: 150))
        view.addSubview(rectView)
    }
    
    func drawLine(start: CGPoint, end: CGPoint) {
        // PATH
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.close()
        
        //LAYER
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.path = path.cgPath
        
        //ADD LAYER
        self.view.layer.addSublayer(shapeLayer)
    }

}

