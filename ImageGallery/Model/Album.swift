//
//  Album.swift
//  ImageGallery
//
//  Created by Kobayashi on 25/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import Foundation

class Album {
    var id: Int
    var title: String
    var photos: [Photo]
    
    init(albumId: Int, albumName: String, algumPhotos: [Photo]) {
        id = albumId
        title = albumName
        photos = algumPhotos
    }
    
}
