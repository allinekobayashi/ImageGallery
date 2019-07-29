//
//  AlbumServiceTests.swift
//  ImageGalleryTests
//
//  Created by Kobayashi on 28/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import XCTest
@testable import ImageGallery

class AlbumServiceTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    
    func testProcessDataForAlbum() {
        //1. Given
        let albumFromJson1 = AlbumElement(userID: 10, id: 1, title: "Album test 1")
        let albumFromJson2 = AlbumElement(userID: 10, id: 2, title: "Album test 2")
        let albumsFromJson = [albumFromJson1, albumFromJson2]
        
        //2. When
        let albums = AlbumServiceMock.shared.processData(data: albumsFromJson)
        
        //3. Then
        XCTAssertEqual(albums.count, 2)
        
        XCTAssertEqual(albums[0].id, 1)
        XCTAssertEqual(albums[0].title, "1 - Album test 1")
        XCTAssertEqual(albums[0].photos.count, 0)
        
        XCTAssertEqual(albums[1].id, 2)
        XCTAssertEqual(albums[1].title, "2 - Album test 2")
        XCTAssertEqual(albums[1].photos.count, 0)
    }
    
    func testProcessDataForPhoto() {
        //1. Given
        let photoFromJson1 = PhotosElement(albumID: 1, id: 1, title: "Photo1 test", url: "url photo 1", thumbnailURL: "thumbnailURL photo 1")
        let photoFromJson2 = PhotosElement(albumID: 2, id: 2, title: "Photo2 test", url: "url photo 2", thumbnailURL: "thumbnailURL photo 2")
        let photosFromJson = [photoFromJson1, photoFromJson2]
        
        //2. When
        let photos = AlbumServiceMock.shared.processData(data: photosFromJson)
        
        //3. Then
        XCTAssertEqual(photos.count, 2)
        
        XCTAssertEqual(photos[0].id, 1)
        XCTAssertEqual(photos[0].title, "Photo1")
        XCTAssertEqual(photos[0].imageURL, "thumbnailURL photo 1")
        
        XCTAssertEqual(photos[1].id, 2)
        XCTAssertEqual(photos[1].title, "Photo2")
        XCTAssertEqual(photos[1].imageURL, "thumbnailURL photo 2")
    }
    
    func testFetchAlbumsForUser() {
        
        //1. Given userID = 1 When
        AlbumServiceMock.shared.fetchAlbumsForUser(userID: 1, completionHandler: { albums, error in
            //3. Then
            XCTAssertNil(error)
            XCTAssertEqual(albums.count, 2)
            
            XCTAssertEqual(albums[0].id, 1)
            XCTAssertEqual(albums[0].title, "1 - quidem molestiae enim")
            XCTAssertEqual(albums[0].photos.count, 0)
            
            XCTAssertEqual(albums[1].id, 2)
            XCTAssertEqual(albums[1].title, "2 - sunt qui excepturi placeat culpa")
            XCTAssertEqual(albums[1].photos.count, 0)
        })
    }
    
}

class AlbumServiceMock: AlbumService {
    override func fetchData(from urlString: String, completionHandler: @escaping ServiceDataCompletion) {
        var mockFile: String?
        var mockFileType: String?
        switch urlString {
        case "\(baseURLString)/albums?userId=1":
            mockFile = "Albums"
            mockFileType = "json"
        case "\(baseURLString)/photos?albumId=1":
            mockFile = "Photos"
            mockFileType = "json"
        
        default:
            mockFile = nil
        }

        let testBundle = Bundle(for: type(of: self))
        
        if let path = testBundle.path(forResource: mockFile, ofType: mockFileType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                completionHandler(data, nil)
            } catch {
                completionHandler([], .Unknown)
            }
        }
        
    }
}
