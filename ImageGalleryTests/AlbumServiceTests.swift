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
    
    #warning("1. Async test: expectation")
    func testFetchAlbumsForUser() {
        //1. Given
        let expectation = self.expectation(description: "Async call Albums")
        var result: [Album] = []
        
        //2. When
        AlbumServiceMock.sharedMock.fetchAlbumsForUser(userID: 1) { albums, error in
            result = albums
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        
        //3. Then
        XCTAssertEqual(result.count, 2)
                
        XCTAssertEqual(result[0].id, 1)
        XCTAssertEqual(result[0].title, "1 - quidem molestiae enim")
        XCTAssertEqual(result[0].photos.count, 0)
                
        XCTAssertEqual(result[1].id, 2)
        XCTAssertEqual(result[1].title, "2 - sunt qui excepturi placeat culpa")
        XCTAssertEqual(result[1].photos.count, 0)
    }
    
    func testFetchPhotosPerAlbum() {
        //1. Given
        let expectation = self.expectation(description: "Async call Photos")
        var result: [Photo] = []
        
        //2. When
        AlbumServiceMock.sharedMock.fetchPhotosPerAlbum(albumID: 1) { photos, error in
            result = photos
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        
        //3. Then
        XCTAssertEqual(result.count, 3)
        
        XCTAssertEqual(result[0].id, 1)
        XCTAssertEqual(result[0].title, "accusamus")
        XCTAssertEqual(result[0].imageURL, "https://via.placeholder.com/150/92c952")
        
        XCTAssertEqual(result[1].id, 2)
        XCTAssertEqual(result[1].title, "reprehenderit")
        XCTAssertEqual(result[1].imageURL, "https://via.placeholder.com/150/771796")
        
        XCTAssertEqual(result[2].id, 3)
        XCTAssertEqual(result[2].title, "officia")
        XCTAssertEqual(result[2].imageURL, "https://via.placeholder.com/150/24f355")
    }
    
}

class AlbumServiceMock: AlbumService {
    #warning("1. Tests with singletons")
    static let sharedMock = AlbumServiceMock()
    
    override init() {
    }
    
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
        
        guard mockFile != nil else {
            completionHandler([], .FailedRequestFromServer)
            return
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
