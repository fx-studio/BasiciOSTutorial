//
//  FxRectangularView.swift
//  04Drawing
//
//  Created by Le Phuong Tien on 10/17/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import UIKit

class FxRectangularView: UIView {

    override func draw(_ rect: CGRect) {
        // create path
        let path = createPath()
        
        // fill
        let fillColor = UIColor.orange
        fillColor.setFill()
        path.fill()
    }
    
    func createPath() -> UIBezierPath {
        let path = UIBezierPath(rect: self.bounds)
        return path
    }

}
