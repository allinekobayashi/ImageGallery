//
//  AlbumDetailCollectionViewController.swift
//  ImageGallery
//
//  Created by Kobayashi on 25/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "AlbumDetailCollectionViewCell"

class AlbumDetailCollectionViewController: UICollectionViewController {
    var album: Album? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindWith(album: Album) {
        self.album = album
        self.title = album.title
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let album = self.album else { return 0 }
        return album.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumDetailCollectionViewCell
        guard let album = self.album else { return cell }
        cell.albumItem = album.photos[indexPath.row]
        cell.bindWith(albumItem: album.photos[indexPath.row])
        return cell
    }

}
