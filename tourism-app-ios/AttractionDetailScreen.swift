//
//  AttractionDetailScreen.swift
//  tourism-app-ios
//
//  Created by user182559 on 11/26/20.
//  Copyright © 2020 Matheus. All rights reserved.
//

import UIKit

class AttractionDetailScreen: UIViewController {

    // Outlets
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelPricing: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var ivHeart: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    // Variables
    var attraction:Attraction = Attraction()
    var json = JsonEssentials()
    var number = 0
    
    // Default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load attraction features
        self.labelDescription.text = self.attraction.description
        self.labelTitle.text = self.attraction.name
        self.labelAddress.text = "Address: \(self.attraction.address ?? "")"
        self.labelPhone.text = "Phone No.: \(self.attraction.phone ?? "")"
        self.labelPricing.text = "Pricing: R$ \(self.attraction.pricing ?? 0)"
        self.ivImage.image = UIImage(named: "\(self.attraction.image!)")
        
        // Enable heart to change image
        self.ivHeart.isUserInteractionEnabled = true
        self.ivHeart.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.heartChange)))

        // Enable main image to change
        self.ivImage.isUserInteractionEnabled = true
        self.ivImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageChange)))
        
        // Load wishlist
        let isFavorite = checkIfIsFavorite()
        if isFavorite == true {
            self.ivHeart.restorationIdentifier = "red"
            self.ivHeart.image = UIImage(named: "heart_red")
        } else {
            ivHeart.restorationIdentifier = "black"
        }
        
    }
    
    // Load wishlist
    func checkIfIsFavorite() -> Bool {
        var response = false
        if let filePath = self.append(toPath: self.documentDirectory(), withPathComponent: "wishlist") {
            do {
                let contents = try String(contentsOfFile: filePath)
                let jsonData = contents.data(using: .utf8)!
                let att = try! JSONDecoder().decode([Attraction].self, from:jsonData)
                for i in 0...(att.count - 1) {
                    if (att[i].name == self.labelTitle.text!) {
                        response = (att[i].favorite)!
                    }
                }
            } catch {
                print("Cannot load file")
            }
        } else {
            print("File not found")
        }
        return response
    }

    
    // Update wishlist
    func updateWishlist() {
        if let filePath = self.append(toPath: self.documentDirectory(), withPathComponent: "wishlist") {
            do {
                let contents = try String(contentsOfFile: filePath)
                let jsonData = contents.data(using: .utf8)!
                var att = try! JSONDecoder().decode([Attraction].self, from:jsonData)
                for i in 0...(att.count - 1) {
                    if (att[i].name == self.labelTitle.text!) {
                        if (att[i].favorite == false) {
                            att[i].favorite = true
                        } else {
                            att[i].favorite = false
                        }
                    }
                }
                self.json.saveAttractionData(program: att, fileToSaveTo: "wishlist")
                print("Saved")
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
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)
        return documentDirectory[0]
    }
    
    // Change heart image red-black
    @objc func heartChange() {
        if (self.ivHeart.restorationIdentifier == "red") {
            self.ivHeart.restorationIdentifier = "black"
            self.ivHeart.image = UIImage(named: "heart_black")
        } else {
            self.ivHeart.restorationIdentifier = "red"
            self.ivHeart.image = UIImage(named: "heart_red")
        }
        self.updateWishlist()
    }
    
    // Change main image
    @objc func imageChange() {
        let imageName = self.attraction.image!
        let imageArray = [imageName, imageName + "_2", imageName + "_3"]
        var number:Int
        repeat {
            number = Int.random(in:0...2)
        } while number == self.number
        self.number = number
        self.ivImage.image = UIImage(named: imageArray[self.number])
    }

    // Go to safari
    @IBAction func goToUrl(_ sender: Any) {
        if let url = URL(string: self.attraction.website!) {
            UIApplication.shared.open(url)
        }
    }

}
