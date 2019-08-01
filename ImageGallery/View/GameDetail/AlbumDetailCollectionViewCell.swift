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
    private var dataTask: URLSessionDataTask?
    
    func bindWith(albumItem: Photo) {
        self.photoLabel.text = albumItem.title
        
        let task = AlbumService.shared.createImageTask(imageURL: albumItem.imageURL) { [weak self] newImage, error in
            if let image = newImage, error == nil {
                self?.photoImage.image = image
            }
        }
        
        task?.resume()
        self.dataTask = task
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dataTask?.cancel()
        dataTask = nil
        
        photoImage.image = UIImage(named: "imageDefault")
    }

}
