//
//  AlbumsonElement.swift
//  ImageGallery
//
//  Created by Kobayashi on 26/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import Foundation

// MARK: - AlbumsonElement
struct AlbumElement: Codable {
    let userID, id: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}

typealias Albums = [AlbumElement]
