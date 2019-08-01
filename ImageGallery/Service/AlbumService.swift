//
//  AlbumService.swift
//  ImageGallery
//
//  Created by Kobayashi on 26/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import Foundation
import UIKit

class AlbumService {
    
    static let shared = AlbumService()
    
    let baseURLString: String = "https://jsonplaceholder.typicode.com"
    let  imageCache = NSCache<NSString, UIImage>()
    
    typealias PhotosCompletion = ([Photo], DataManagerError?) -> ()
    typealias AlbumsCompletion = ([Album], DataManagerError?) -> ()
    typealias ServiceDataCompletion = (Any, DataManagerError?) -> ()
    
//    private init() {
//    }
//
    // When testing, use this init:
    init() {
    }
    
    /*Another solution for caching: */
//    private var session: URLSession {
//        let config = URLSessionConfiguration.default
//        config.requestCachePolicy = .returnCacheDataElseLoad
//
//        return URLSession(configuration: config)
//    }
        
    func fetchAlbumsForUser(userID: Int, completionHandler: @escaping AlbumsCompletion) {
        let albumURL = "\(baseURLString)/albums?userId=\(userID)"

        self.fetchData(from: albumURL, completionHandler: { data, error  in
            guard let dataFromServer = data as? Data, let albums = try? JSONDecoder().decode(Albums.self, from: dataFromServer), error == nil else {
                DispatchQueue.main.async {
                    error == nil ? completionHandler([], .InvalidResponseFromServer) : completionHandler([], error)
                }
                return
            }
            let newAlbums = self.processData(data: albums)
            DispatchQueue.main.async {
                completionHandler(newAlbums, nil)
            }
        })
    }
    
    func fetchPhotosPerAlbum(albumID: Int, completionHandler: @escaping PhotosCompletion) {
        let photosURL = "\(baseURLString)/photos?albumId=\(albumID)"
        
        fetchData(from: photosURL, completionHandler: { dataFromServer, error  in
            guard let data = dataFromServer as? Data, let photos = try? JSONDecoder().decode(Photos.self, from: data), error == nil else {
                error == nil ? completionHandler([], .InvalidResponseFromServer) : completionHandler([], error)
                return
            }
            let listOfPhotos = self.processData(data: photos)
            completionHandler(listOfPhotos, nil)
        })
    }
    
    func fetchData(from urlString: String, completionHandler: @escaping ServiceDataCompletion) {
        
        guard let url = URL(string: urlString) else { return }
    
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                error != nil ? completionHandler([], .FailedRequestFromServer) : completionHandler([], .Unknown)
                return
            }
            completionHandler(data, nil)
        }
        
        DispatchQueue.global(qos: .background).async {
            task.resume()
        }
        
    }
    
    func processData(data: Albums) -> [Album] {
        var listOfAlbums: [Album] = []
        var newAlbum: Album
        for album in data {
            newAlbum = Album(albumId: album.id, albumName: "\(album.id) - \(album.title)", algumPhotos: [])
            listOfAlbums.append(newAlbum)
        }
        return listOfAlbums
    }
    
    func processData(data: Photos) -> [Photo] {
        var listOfPhotos: [Photo] = []
        
        for photo in data {
            let shortTitle = photo.title.components(separatedBy: " ").first ?? ""
            var newPhoto: Photo
            newPhoto = Photo(elementId: photo.id,text: shortTitle, url: photo.thumbnailURL)
            listOfPhotos.append(newPhoto)
        }
        return listOfPhotos
    }
    
    func fetchImage(imageURL: String, completionHandler: @escaping (UIImage?, DataManagerError?) -> ()) {
        fetchData(from: imageURL, completionHandler: { data, error  in
            guard let imageData = data as? Data, let image = UIImage(data: imageData) else {
                DispatchQueue.main.async {
                    completionHandler(nil, .InvalidResponseFromServer)
                }
                return
            }
            
            self.imageCache.setObject(image, forKey: imageURL as NSString)
            DispatchQueue.main.async {
                completionHandler(image, nil)
            }
            
        })
    }
    
    func getImage(imageURL: String, completionHandler: @escaping (UIImage?, DataManagerError?) -> ()) {
        if let image = imageCache.object(forKey: imageURL as NSString) {
            completionHandler(image, nil)
        } else {
            fetchImage(imageURL: imageURL, completionHandler: completionHandler)
        }
    }
    
    func createImageTask(imageURL: String, completionHandler: @escaping (UIImage?, DataManagerError?) -> ()) -> (URLSessionDataTask?) {
        guard let url = URL(string: imageURL) else { return nil}
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                error != nil ? completionHandler(nil, .FailedRequestFromServer) : completionHandler(nil, .Unknown)
                return
            }
            
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completionHandler(nil, .InvalidResponseFromServer)
                }
                return
            }
            
            self.imageCache.setObject(image, forKey: imageURL as NSString)
            DispatchQueue.main.async {
                completionHandler(image, nil)
            }
        }
        
        return task
        
    }
    
}
