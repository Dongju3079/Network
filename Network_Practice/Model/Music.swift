//
//  Music.swift
//  Network_Practice
//
//  Created by Macbook on 2023/07/31.
//

import Foundation

// MARK: - Welcome
struct MusicData: Codable {
    let musicCount: Int
    let results: [Music]
    
    enum CodingKeys: String, CodingKey {
        case musicCount = "resultCount"
        case results
    }
}

// MARK: - Result
struct Music: Codable {
    let artistName: String?
    let collectionName: String?
    let musicName: String?
    let imageUrl: String?
    let releaseDate: String?
    

    enum CodingKeys: String, CodingKey {
        case artistName
        case collectionName
        case musicName = "trackName"
        case imageUrl = "artworkUrl100"
        case releaseDate
    }
}
