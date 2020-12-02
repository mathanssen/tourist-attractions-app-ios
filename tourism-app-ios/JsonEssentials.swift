//
//  JsonEssentials.swift
//  tourism-app-ios
//
//  Created by user182559 on 11/27/20.
//  Copyright © 2020 Matheus. All rights reserved.
//

import Foundation

struct JsonEssentials {
    
    // Properties
    var users:[UserAccount] = []
    var attractions:[Attraction] = []
        
    // Initializer
    init() {}
    
    // Functions for UserAccount class
    mutating func loadUserData(filename:String) {
        if let filepath = Bundle.main.path(forResource:filename, ofType:"json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let jsonData = contents.data(using: .utf8)!
                self.users = try! JSONDecoder().decode([UserAccount].self, from:jsonData)
            } catch {
                print("Cannot load file")
            }
        } else {
            print("File not found")
        }
    }
    
    func saveUserData(program:[UserAccount], fileToSaveTo:String) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(program)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let finalPath = paths[0]

                let filename = finalPath.appendingPathComponent(fileToSaveTo)

                try jsonString.write(to: filename, atomically:true, encoding: String.Encoding.utf8)
            }
            else {
                print("Error when converting data to a string")
            }
        }
        catch {
            print("Error converting or saving to JSON")
            print(error.localizedDescription)
        }
    }
    
    
    // Load registered users
    func loadUsersFromStorage() -> [UserAccount] {
        if let filePath = self.append(toPath: self.documentDirectory(), withPathComponent: "registeredUsers") {
            do {
                let contents = try String(contentsOfFile: filePath)
                let jsonData = contents.data(using: .utf8)!
                let registeredUsers = try! JSONDecoder().decode([UserAccount].self, from:jsonData)
                return registeredUsers
            } catch {
                print("Cannot load file")
                return []
            }
        } else {
            print("File not found")
            return []
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
    
    
    // Check if file exists
    func fileExists(file:String) -> Bool {
        var response = false
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(file) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                response = true
            } else {
                response = false
            }
        } else {
            response = false
            print("FILE PATH NOT AVAILABLE")
        }
        return response
    }

    // Functions for Attraction class
    mutating func loadAttractionData(filename:String) {
        if let filepath = Bundle.main.path(forResource:filename, ofType:"json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let jsonData = contents.data(using: .utf8)!
                self.attractions = try! JSONDecoder().decode([Attraction].self, from:jsonData)
            } catch {
                print("Cannot load file")
            }
        } else {
            print("File not found")
        }
    }
    
    func saveAttractionData(program:[Attraction], fileToSaveTo:String) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(program)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let finalPath = paths[0]

                let filename = finalPath.appendingPathComponent(fileToSaveTo)

                try jsonString.write(to: filename, atomically:true, encoding: String.Encoding.utf8)
            }
            else {
                print("Error when converting data to a string")
            }

        }
        catch {
            print("Error converting or saving to JSON")
            print(error.localizedDescription)
        }
    }
    
}
