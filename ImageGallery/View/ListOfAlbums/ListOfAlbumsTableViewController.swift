//
//  ListOfAlbumsTableViewController.swift
//  ImageGallery
//
//  Created by Kobayashi on 25/07/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ListOfAlbumsTableViewCell"
private let segueIdentifier = "ShowAlbumDetailSegue"

class ListOfAlbumsTableViewController: UITableViewController {
    var listOfAlbums: [Album] = []
    @IBOutlet var listOfAlbumsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var dataManager:DataManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "List of Albums"
        self.activityIndicator.startAnimating()
        
        dataManager = DataManager(context: self.context)
        dataManager?.loadAlbums(completionHandler: { albums, error in
            guard error == nil else {
                self.activityIndicator.stopAnimating()
                self.showError(error!)
                return
            }
            
            self.listOfAlbums = albums
            self.listOfAlbumsTableView.reloadData()
            self.activityIndicator.stopAnimating()
        })
        
    }

    // MARK: - Error Handle
    private func showError(_ error: DataManagerError) {
        var errorMessage: String
        switch error {
        case .DatabaseNotSaved:
            errorMessage = "We couldn't save your data."
        case .FailedRequestFromDatabase:
            errorMessage = "Error when accessing the database."
        case .FailedRequestFromServer:
            errorMessage = "We couldn't connect to the server."
        case .InvalidDatabase:
            errorMessage = "Invalid database."
        case .InvalidResponseFromServer:
            errorMessage = "We have a problem with your data."
        case .Unknown:
            errorMessage = "An error occurred."
        }
        errorMessage += " Please, try again later"
        
        let alert = UIAlertController(title: "Ops...", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return listOfAlbums.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listOfAlbums[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ListOfAlbumsTableViewCell
        cell.bindWith(newAlbum: listOfAlbums[indexPath.section])

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let albumDetailVC = segue.destination as! AlbumDetailCollectionViewController
        let senderCell = sender as! AlbumCollectionViewCell
        
        guard segue.identifier == segueIdentifier, let manager = self.dataManager, let selectedAlbum = manager.findAlbum(allAlbums: listOfAlbums, albumID: senderCell.albumID) else {return}
        albumDetailVC.bindWith(album: selectedAlbum)
    }
    
}
