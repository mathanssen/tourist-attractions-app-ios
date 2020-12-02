//
//  WishlistScreen.swift
//  tourism-app-ios
//
//  Created by user182559 on 11/26/20.
//  Copyright © 2020 Matheus. All rights reserved.
//

import UIKit

class WishlistScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var wishlist:[Attraction] = []
    var attraction = Attraction()

    // Default function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.wishlist = []
        self.loadWishlist()
        self.tableView.reloadData()
        
        // Additional table view configuration
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }
    
    // Table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wishlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: "wishlistCell") as? WishlistTableViewCell
        
        if (cell == nil) {
            cell = WishlistTableViewCell()
        }
        
        cell?.labelTitle.text = self.wishlist[indexPath.row].name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.attraction = self.wishlist[indexPath.row]
    }
    
    // Load wishlist
    func loadWishlist() {
        if let filePath = self.append(toPath: self.documentDirectory(), withPathComponent: "wishlist") {
            do {
                let contents = try String(contentsOfFile: filePath)
                let jsonData = contents.data(using: .utf8)!
                let att = try! JSONDecoder().decode([Attraction].self, from:jsonData)
                for i in 0...(att.count - 1) {
                    if (att[i].favorite! == true) {
                        self.wishlist.append(att[i])
                    }
                }
            } catch {
                print("Cannot load file")
            }
        } else {
            print("File not found")
        }
    }
    
    private func append(toPath path: String, withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            return pathURL.absoluteString
        }
        return nil
    }
    
    private func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0]
    }
    

}
