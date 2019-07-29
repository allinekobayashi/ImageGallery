//
//  PhotosJSONElement.swift
//  ImageGallery
//
//  Created by Kobayashi on 26/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//
import Foundation

struct PhotosElement: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

typealias Photos = [PhotosElement]
