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
    private var dataTask: URLSessionDataTask?
    
    func bindWith(albumItem: Photo, albumID: Int) {
        
        self.albumID = albumID
        
        #warning("3. Strong reference cycle")
        let task = AlbumService.shared.createImageTask(imageURL: albumItem.imageURL) { [weak self] newImage, error in
            if let image = newImage, error == nil {
                self?.photoImage.image = image
            }
        }
        
        #warning("2. Background task (I was blocking the main thread -> white screen)")
        DispatchQueue.global(qos: .background).async {
            task?.resume()
        }
        
        self.dataTask = task
    }
    
    #warning("4. Stoping request")
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dataTask?.cancel()
        dataTask = nil
        
        photoImage.image = UIImage(named: "imageDefault")
    }
    
}
