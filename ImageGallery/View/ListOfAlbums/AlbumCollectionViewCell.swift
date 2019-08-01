//
//  AlbumCollectionViewCell.swift
//  ImageGallery
//
//  Created by Kobayashi on 25/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import UIKit
import Photos

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    var albumID: Int = -1
    
    func bindWith(albumItem: Photo, albumID: Int) {
        self.albumID = albumID
        
        #warning("Strong reference cycle?")
        AlbumService.shared.getImage(imageURL: albumItem.imageURL) { [weak self] newImage, error in
            if let image = newImage, error == nil {
                self?.photoImage.image = image
            }
        }
        
    }
    
}
