//
//  Music.swift
//  ProtocolVSClosure
//
//  Created by Le Phuong Tien on 12/28/20.
//

import Foundation

struct Music: Codable {
    var artistName: String
    var id: String
    var releaseDate: String
    var name: String
    var kind: String
    var copyright: String
    var artistId: String
    var artworkUrl100: String
}

struct MusicFeed : Codable {
    var results: [Music]
}

struct MusicResult: Codable {
    var feed: MusicFeed
}
