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
        encode1(album)
        return saveDatabaseContext()
    }
    
    func encode1(_ album: Album){
        let albumManagedObject = AlbumManagedObject(context: context)
        albumManagedObject.id = Int64(album.id)
        albumManagedObject.title = album.title
        let _ = encode(album.photos, fromAlbum: albumManagedObject)
    }
    
    func encode(_ photos: [Photo], fromAlbum albumManagedObject: AlbumManagedObject) -> [PhotoManagedObject] {
        var arrayOfPhotos: [PhotoManagedObject] = []
        for photo in photos {
            let photoManagedObject = PhotoManagedObject(context: context)
            photoManagedObject.id = Int64(photo.id)
            photoManagedObject.title = photo.title
            photoManagedObject.imageURL = photo.imageURL
            photoManagedObject.addToAlbums(albumManagedObject)
            
            arrayOfPhotos.append(photoManagedObject)
        }
        return arrayOfPhotos
    }
    
    func saveDatabaseContext() -> DataManagerError? {
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
    
    func decode(_ listOfAlbumManagedObject: [AlbumManagedObject]) -> [Album] {
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
    
    func decode(_ setOfPhotos: NSSet) -> [Photo] {
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
