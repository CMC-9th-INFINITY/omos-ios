//
//  Select.swift
//  Omos
//
//  Created by sangheon on 2022/03/02.
//

import Foundation

struct SelectResponse: Codable {
    let aLine: [ALine]
    let ost: [ALine]
    let lyrics: [ALine]
    let free: [ALine]
    let story: [ALine]

    enum CodingKeys: String, CodingKey {
        case aLine = "A_LINE"
        case ost = "OST"
        case lyrics = "LYRICS"
        case free = "FREE"
        case story = "STORY"
    }
}

// MARK: - ALine
struct ALine: Codable {
    let music: Music
    let recordTitle: String
    let userID: Int
    let nickname: String
    let recordID: Int

    enum CodingKeys: String, CodingKey {
        case music, recordTitle
        case userID = "userId"
        case nickname
        case recordID = "recordId"
    }
}

// MARK: - Music
struct Music: Codable {
    let albumImageURL, albumTitle: String
    let artists: [Artist]
    let musicID, musicTitle: String

    enum CodingKeys: String, CodingKey {
        case albumImageURL = "albumImageUrl"
        case albumTitle, artists
        case musicID = "musicId"
        case musicTitle
    }
}

// MARK: - Artist
struct Artist: Codable {
    let artistID, artistName: String

    enum CodingKeys: String, CodingKey {
        case artistID = "artistId"
        case artistName
    }
}
///이거 아직 서버 안한듯 
struct testArtist:Codable {
    let artistName: String
}
