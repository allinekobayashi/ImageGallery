//
//  AlbumsStorage.swift
//  ImageGallery
//
//  Created by Kobayashi on 26/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import Foundation
import CoreData

class AlbumsStorage {
    private let context : NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save(_ album: Album) -> DataManagerError? {
        encode(album)
        return saveDatabaseContext()
    }
    
    private func encode(_ album: Album){
        let albumManagedObject = AlbumManagedObject(context: context)
        albumManagedObject.id = Int64(album.id)
        albumManagedObject.title = album.title
        encode(album.photos, fromAlbum: albumManagedObject)
    }
    
    private func encode(_ photos: [Photo], fromAlbum albumManagedObject: AlbumManagedObject ) {
        for photo in photos {
            let photoManagedObject = PhotoManagedObject(context: context)
            photoManagedObject.id = Int64(photo.id)
            photoManagedObject.title = photo.title
            photoManagedObject.imageURL = photo.imageURL
            photoManagedObject.addToAlbums(albumManagedObject)
        }
    }
    
    private func saveDatabaseContext() -> DataManagerError? {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                return .DatabaseNotSaved
            }
        } else {
            return .DatabaseNotSaved
        }
        return nil
    }
    
    func fetchAlbums(completionHandler: @escaping ([Album], DataManagerError?) -> ()) {
        let fetchRequest: NSFetchRequest<AlbumManagedObject> = AlbumManagedObject.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(AlbumManagedObject.id), ascending: true)]
        
        context.performAndWait {
            do {
                let albumsManagedObject = try fetchRequest.execute()
                let albums = decode(albumsManagedObject)
                completionHandler(albums, nil)
            } catch {
                completionHandler([], .FailedRequestFromDatabase)
            }
        }
    }
    
    private func decode(_ listOfAlbumManagedObject: [AlbumManagedObject]) -> [Album] {
        var albums: [Album] = []
        var album: Album
        
        for albumManagedObject in listOfAlbumManagedObject {
            guard let photoSet = albumManagedObject.photos else {return []}
            var listOfPhoto = decode(photoSet)
            listOfPhoto.sort { $0.id < $1.id}
            album = Album(albumId: Int(albumManagedObject.id), albumName: albumManagedObject.title ?? "", algumPhotos: listOfPhoto)
            albums.append(album)
        }
        return albums
    }
    
    private func decode(_ setOfPhotos: NSSet) -> [Photo] {
        var photos: [Photo] = []
        for photo in setOfPhotos {
            if let photoManagedObject = photo as? PhotoManagedObject {
                let photo = Photo(elementId: Int(photoManagedObject.id), text: photoManagedObject.title ?? "", url: photoManagedObject.imageURL ?? "")
                photos.append(photo)
            }
        }
        return photos
    }
    
}
