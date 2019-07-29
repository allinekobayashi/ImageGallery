//
//  ListOfAlbumsTableViewCell.swift
//  ImageGallery
//
//  Created by Kobayashi on 25/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import UIKit

class ListOfAlbumsTableViewCell: UITableViewCell {
    var album: Album? = nil
    
    func bindWith(newAlbum: Album) {
        album = newAlbum
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ListOfAlbumsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let album = self.album else { return 0 }
        return album.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
        guard let album = self.album else { return cell }
        cell.bindWith(albumItem: album.photos[indexPath.row], albumID: album.id)
        return cell
    }
}
