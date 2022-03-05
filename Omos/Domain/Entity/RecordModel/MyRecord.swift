//
//  MyRecord.swift
//  Omos
//
//  Created by sangheon on 2022/03/04.
//

import Foundation

// MARK: - CategoryElement
// MARK: - MyRecordElement
struct MyRecordRespone: Codable {
    let category, createdDate: String
    let isPublic: Bool
    let music: Music
    let recordContents: String
    let recordID: Int
    let recordImageURL:String?
    let recordTitle: String

    enum CodingKeys: String, CodingKey {
        case category, createdDate, isPublic, music, recordContents
        case recordID = "recordId"
        case recordImageURL = "recordImageUrl"
        case recordTitle
    }
}



// MARK: - MyRecord
struct SaveRequest: Codable { // add imageURL or image data using form - data
    let category, contents: String
    let isPublic: Bool
    let musicID, title: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case category, contents, isPublic
        case musicID = "musicId"
        case title
        case userID = "userId"
    }
}

struct SaveRespone:Codable {
    let postID: Int
    
    enum CodingKeys: String, CodingKey {
        case postID = "postId"
    }
}
