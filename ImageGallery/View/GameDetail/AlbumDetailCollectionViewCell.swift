//
//  AlbumDetailCollectionViewCell.swift
//  ImageGallery
//
//  Created by Kobayashi on 25/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import UIKit
import Photos

class AlbumDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    var albumItem: Photo?
    
    func bindWith(albumItem: Photo) {
        self.photoLabel.text = albumItem.title
        AlbumService.shared.getImage(imageURL: albumItem.imageURL) { newImage, error in
            if let image = newImage, error == nil {
                self.photoImage.image = image
            }
        }
        
    }

}
