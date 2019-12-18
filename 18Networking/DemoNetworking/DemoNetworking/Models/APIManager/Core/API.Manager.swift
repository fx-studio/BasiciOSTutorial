//
//  API.Manager.swift
//  DemoNetworking
//
//  Created by Le Phuong Tien on 12/17/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import Foundation

struct APIManager {
    //MARK: Config
    struct Path {
        static let base_domain = "https://rss.itunes.apple.com"
        static let base_path = "/api/v1/us"
        
        static let music_path = "/itunes-music"
        static let music_hot = "/hot-tracks"
    }
    
    //MARK: - Domain
    struct Music {}
    
    struct Downloader {}
}
