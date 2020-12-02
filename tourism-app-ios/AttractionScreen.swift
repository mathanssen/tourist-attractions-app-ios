//
//  AttractionScreen.swift
//  tourism-app-ios
//
//  Created by user182559 on 11/26/20.
//  Copyright © 2020 Matheus. All rights reserved.
//

import UIKit

class AttractionScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var tableViewAttraction: UITableView!
    
    // Variables
    var userAccount = UserAccount()
    var attraction = Attraction()

    // Data
    var json:JsonEssentials = JsonEssentials()
    
    // Default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load attraction data
        self.json.loadAttractionData(filename: "attraction")
        
        // Create wishlist if not exists
        let fileExists = self.json.fileExists(file: "wishlist")
        if (fileExists == false) {
            self.json.saveAttractionData(program: self.json.attractions, fileToSaveTo: "wishlist")
        }
        
        // Additional table view configuration
        self.tableViewAttraction.dataSource = self
        self.tableViewAttraction.delegate = self
        
        // Table view cell size
        tableViewAttraction.rowHeight = 100
    }
    
    // Table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.json.attractions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableViewAttraction.dequeueReusableCell(withIdentifier: "attractionListCell") as? AttractionTableViewCell
        
        if (cell == nil) {
            cell = AttractionTableViewCell()
        }
        
        cell?.ivImage.image = UIImage(named: self.json.attractions[indexPath.row].image!)
        cell?.labelTitle.text = self.json.attractions[indexPath.row].name
        cell?.labelDescription.text = self.json.attractions[indexPath.row].description
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.attraction = self.json.attractions[indexPath.row]
        performSegue(withIdentifier: "fromListToDetailsSegue", sender: nil)
    }
    
    // Transfer data to details screen
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "fromListToDetailsSegue" {
            let detailsScreen = segue.destination as! AttractionDetailScreen
            detailsScreen.attraction = self.attraction
        }
    }

}


