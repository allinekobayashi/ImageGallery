//
//  DataManager.swift
//  ImageGallery
//
//  Created by Kobayashi on 26/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import Foundation
import CoreData

enum DataManagerError: Error {
    case Unknown
    case FailedRequestFromServer
    case InvalidResponseFromServer
    case FailedRequestFromDatabase
    case InvalidDatabase
    case DatabaseNotSaved
}

class DataManager {
    let storage: AlbumsStorage?
    let userID: Int = 1
    
    init(context: NSManagedObjectContext) {
        self.storage = AlbumsStorage(context: context)
    }
    
    func loadAlbums(completionHandler: @escaping ([Album], DataManagerError?) -> ()) {
        guard let albumsStorage = self.storage else {
            completionHandler([], .InvalidDatabase)
            return
        }
        
        albumsStorage.fetchAlbums(completionHandler: { albumsFromDB, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler([], error)
                }
                return
            }
            
            if albumsFromDB.isEmpty {
                self.updateDatabase(completionHandler: { albumsFromServer, error in
                    DispatchQueue.main.async {
                        completionHandler(albumsFromServer, error)
                    }
                })
            } else {
                DispatchQueue.main.async {
                    completionHandler(albumsFromDB, nil)
                }
            }
        })
    }
    
    private func updateDatabase(completionHandler: @escaping ([Album], DataManagerError?) -> ()) {
        AlbumService.shared.fetchAlbumsForUser(userID: self.userID, completionHandler: { albums, error in
            
            guard let albumStorage = self.storage, error == nil, !albums.isEmpty else {
                completionHandler([], error)
                return
            }
            
            var numberOfCompletedRequests = 0
            for album in albums {
                AlbumService.shared.fetchPhotosPerAlbum(albumID: album.id, completionHandler: { photos, error in
                    numberOfCompletedRequests += 1
                    
                    album.photos = photos
                    let error = albumStorage.save(album)
                    
                    if numberOfCompletedRequests == albums.count {
                        completionHandler(albums, error)
                    }
                })
            }
            
            
        })
    }
    
    func findAlbum(allAlbums: [Album], albumID: Int) -> Album? {
        for album in allAlbums {
            if album.id == albumID {
                return album
            }
        }
        return nil
    }

}
