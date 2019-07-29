//
//  Photo.swift
//  ImageGallery
//
//  Created by Kobayashi on 25/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import Foundation

class Photo {
    
    var title: String
    var imageURL: String
    var id: Int
    
    init(elementId: Int, text: String, url: String) {
        id = elementId
        title = text
        imageURL = url
    }
}
