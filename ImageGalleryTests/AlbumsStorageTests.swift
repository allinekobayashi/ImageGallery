//
//  AlbumsStorageTests.swift
//  ImageGalleryTests
//
//  Created by Kobayashi on 28/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import XCTest
import CoreData
@testable import ImageGallery

class AlbumsStorageTests: XCTestCase {
    
    private var context : NSManagedObjectContext!
    private var album: Album?
    private var photos: [Photo] = []
    
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        context = setupCoreDataStack(with: "ImageGallery", in: Bundle.main)
        
        let photo1 = Photo(elementId: 1, text: "Photo 1", url: "https://via.placeholder.com/150/92c952")
        let photo2 = Photo(elementId: 2, text: "Photo 2", url: "https://via.placeholder.com/150/771796")
        
        photos.append(photo1)
        photos.append(photo2)
        album = Album(albumId: 1, albumName: "Album 1", algumPhotos: self.photos)
    }

    override func tearDown() {
        super.tearDown()
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        context = nil
        album = nil
        photos = []
    }

    func testEncodePhoto() {
        
        //1. Given
        let albumMO = AlbumManagedObject(context: self.context)
        albumMO.id = 1
        albumMO.title = "Album 1"
        
        let photoManagedObject1 = PhotoManagedObject(context: self.context)
        photoManagedObject1.id = 1
        photoManagedObject1.title = "Photo 1"
        photoManagedObject1.imageURL = "https://via.placeholder.com/150/92c952"
        photoManagedObject1.addToAlbums(albumMO)
        
        let photoManagedObject2 = PhotoManagedObject(context: self.context)
        photoManagedObject2.id = 2
        photoManagedObject2.title = "Photo 2"
        photoManagedObject2.imageURL = "https://via.placeholder.com/150/771796"
        photoManagedObject2.addToAlbums(albumMO)
        
        let storage: AlbumsStorage = AlbumsStorage(context: self.context)
        
        //2. When
        var arrayOfPhotosManagedObject = storage.encode(self.photos, fromAlbum: albumMO)
        
        //3. Then
        XCTAssertEqual(arrayOfPhotosManagedObject.count, 2)
        XCTAssertEqual(arrayOfPhotosManagedObject[0].id, 1)
        
    }

}
