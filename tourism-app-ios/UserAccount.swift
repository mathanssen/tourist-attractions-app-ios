//
//  UserAccount.swift
//  tourism-app-ios
//
//  Created by user182559 on 11/26/20.
//  Copyright © 2020 Matheus. All rights reserved.
//

import Foundation

struct UserAccount:Codable {
    
    // Properties
    var username:String = ""
    var password:String = ""
    
    // Initializer
    init(username:String, password:String) {
        self.username = username
        self.password = password
    }
    
    init() {}
    
}

