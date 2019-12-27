//
//  MyPin.swift
//  DemoMap
//
//  Created by Le Phuong Tien on 12/26/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import Foundation
import MapKit

class MyPin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
