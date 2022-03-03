//
//  Category.swift
//  Omos
//
//  Created by sangheon on 2022/03/03.
//

import Foundation

// MARK: - CategoryElement
struct CategoryRespone: Codable {
    let music: Music
    let recordID: Int
    let recordTitle, recordContents, createdDate, category: String
    let viewsCnt, userID: Int
    let nickname: String
    let likeCnt, scrapCnt: Int
    let isLiked, isScraped: Bool

    enum CodingKeys: String, CodingKey {
        case music
        case recordID = "recordId"
        case recordTitle, recordContents, createdDate, category, viewsCnt
        case userID = "userId"
        case nickname, likeCnt, scrapCnt, isLiked, isScraped
    }
}


typealias Category = [CategoryRespone]

enum cateType:String,Codable {
    case A_LINE
    case OST
    case STORY
    case LYRICS
    case FREE 
    //정렬
    case ASC = "ASC"
    case DESC = "DESC"
}


struct CateRequest: Codable {
    let page:Int
    let size:Int
    let sort:String
    let userid:Int
}



