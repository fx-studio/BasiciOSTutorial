//
//  FxLineView.swift
//  04Drawing
//
//  Created by Le Phuong Tien on 10/17/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class FxLineView: UIView {
    
    //init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    //draw
    func drawLine(start: CGPoint, end: CGPoint) {
        // PATH
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.close()
        
        //LAYER
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.path = path.cgPath
        
        //ADD LAYER
        self.layer.addSublayer(shapeLayer)
    }

}
