//
//  API.Music.swift
//  DemoNetworking
//
//  Created by Le Phuong Tien on 12/18/19.
//  Copyright © 2019 Fx Studio. All rights reserved.
//

import Foundation

extension APIManager.Music {
    struct QueryString {
        func hotMusic(limit: Int) -> String {
            return APIManager.Path.base_domain +
                APIManager.Path.base_path +
                APIManager.Path.music_path +
                APIManager.Path.music_hot +
                "/all/\(limit)/explicit.json"
        }
    }
    
    struct QueryParam {
    }
    
    struct MusicResult {
        var musics: [Music]
        var copyright: String
        var updated: String
    }
    
    static func getHotMusic(limit: Int = 10, completion: @escaping APICompletion<MusicResult>) {
        let urlString = QueryString().hotMusic(limit: limit)
        
        API.shared().request(urlString: urlString) { (result) in
            switch result {
            case .failure(let error):
                //call back
                completion(.failure(error))
                
            case .success(let data):
                if let data = data {
                    //parse data
                    let json = data.toJSON()
                    let feed = json["feed"] as! JSON
                    let results = feed["results"] as! [JSON]
                    
                    // musics
                    var musics: [Music] = []
                    for item in results {
                        let music = Music(json: item)
                        musics.append(music)
                    }
                    
                    //informations
                    let copyright = "....."
                    let updated = "....."
                    
                    // result
                    let musicResult = MusicResult(musics: musics, copyright: copyright, updated: updated)
                    
                    //call back
                    completion(.success(musicResult))
                    
                } else {
                    //call back
                    completion(.failure(.error("Data is not format.")))
                }
            }
        }
    }
}
