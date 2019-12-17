//
//  Networking.swift
//  DemoNetworking
//
//  Created by Le Phuong Tien on 12/17/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import Foundation

final class Networking {
    //MARK: - singleton
    private static var sharedNetworking: Networking = {
        let networking = Networking()
        return networking
    }()
    
    class func shared() -> Networking {
        return sharedNetworking
    }
    
    //MARK: - init
    private init() {}
}
