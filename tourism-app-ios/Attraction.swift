//
//  Attraction.swift
//  tourism-app-ios
//
//  Created by user182559 on 11/26/20.
//  Copyright © 2020 Matheus. All rights reserved.
//

import Foundation

struct Attraction:Codable {
    
    // Properties
    var name:String?
    var address:String?
    var phone:String?
    var website:String?
    var description:String?
    var pricing:Double?
    var favorite:Bool?
    var image:String?
    
    // Initializer
    init(name:String, address:String, phone:String, website:String, description:String, pricing:Double, favorite:Bool, image:String) {
        self.name = name
        self.address = address
        self.phone = phone
        self.website = website
        self.description = description
        self.pricing = pricing
        self.favorite = favorite
        self.image = image
    }
    
    init() {}
    
    init(name:String, favorite:Bool) {
        self.name = name
        self.favorite = favorite
    }
    
}
