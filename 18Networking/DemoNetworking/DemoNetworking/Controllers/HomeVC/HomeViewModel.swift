//
//  HomeViewModel.swift
//  DemoTabbarController
//
//  Created by Le Phuong Tien on 12/16/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import Foundation

typealias Completion = (Bool, String) -> Void

class HomeViewModel {
    var names: [String] = []
    var musics: [Music] = []
    
    func loadAPI(completion: @escaping Completion) {
        //create request
        let urlString = "https://rss.itunes.apple.com/api/v1/us/itunes-music/hot-tracks/all/100/explicit.json"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        //config
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true

        //session
        let session = URLSession(configuration: config)
        
        //connect
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    if let data = data {
                        let json = data.toJSON()
                        let feed = json["feed"] as! JSON
                        let results = feed["results"] as! [JSON]
                        
                        for item in results {
                            let name = item["name"] as! String
                            self.names.append(name)
                        }
                        
                        completion(true, "")
                    } else {
                       completion(false, "Data format is error.")
                    }
                }
            }
        }
            
        task.resume()
        print("DONE")
    }
    
    func loadAPI2(completion: @escaping Completion) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/itunes-music/hot-tracks/all/10/explicit.json"
        
        Networking.shared().request(with: urlString) { (data, error) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                if let data = data {
                    let json = data.toJSON()
                    let feed = json["feed"] as! JSON
                    let results = feed["results"] as! [JSON]
                    
                    for item in results {
                        let music = Music(json: item)
                        self.musics.append(music)
                        
                        completion(true, "")
                    }
                } else {
                    completion(false, "Data format is error.")
                }
            }
        }
    }
}
