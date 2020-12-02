//
//  ViewController.swift
//  tourism-app-ios
//
//  Created by user182559 on 11/26/20.
//  Copyright © 2020 Matheus. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    // Outlets
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rememberMe: UISwitch!
    
    // Variables
    var json:JsonEssentials = JsonEssentials()
    var userAccount = UserAccount()
    var rememberCredential:String?
    
    // Default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load users
        if (self.json.fileExists(file: "registeredUsers") == false) {
            self.json.loadUserData(filename: "users")
            self.json.saveUserData(program: self.json.users, fileToSaveTo: "registeredUsers")
        } else {
            self.json.users = self.json.loadUsersFromStorage()
        }
        
        // Write credentials if they exist
        let keys = ["username", "password", "rememberMe"]
        if (self.isKeyExistsInUserDefaults(key: keys) == true) {
            let credentials = self.readFromUserDefaults()
            self.username.text = credentials[0]
            self.password.text = credentials[1]
            if (credentials[2] == "yes") {
                self.rememberMe.isOn = true
            } else {
                self.rememberMe.isOn = false
            }
        }
    }
    
    // Check if user is registered
    func isRegistered() -> Bool {
        var response = false
        for user in 0...(self.json.users.count - 1) {
            let username = self.json.users[user].username
            let password = self.json.users[user].password
            if username == self.username.text && password == self.password.text {
                response = true
                break
            }
        }
        return response
    }
    
    // Remember Me
    @IBAction func rememberMeChanged(_ sender: Any) {
        if (self.rememberMe.isOn == true) {
            self.rememberCredential = "yes"
        } else {
            self.rememberCredential = "no"
        }
        print(self.rememberCredential!)
    }
    
    // User Default functions
    func writeToUserDefaults() {
        if (self.username.text! != "Username") {
            let userDefaults = UserDefaults.standard
            userDefaults.set(self.username.text!, forKey:"username")
            userDefaults.set(self.password.text!, forKey:"password")
            userDefaults.set(self.rememberCredential, forKey:"rememberMe")
            print("Saving user credentials...")
        }
    }
    
    func removeFromUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "username")
        userDefaults.removeObject(forKey: "password")
        userDefaults.removeObject(forKey: "rememberMe")
        print("Removing user credentials...")
    }
    
    func readFromUserDefaults() -> [String] {
        var response = ["", "", ""]
        let keys = ["username", "password", "rememberMe"]
        if (isKeyExistsInUserDefaults(key: keys) == true) {
            let userDefaults = UserDefaults.standard
            let usernameSaved = userDefaults.string(forKey: "username")
            let passwordSaved = userDefaults.string(forKey: "password")
            let rememberSaved = userDefaults.string(forKey: "rememberMe")
            print("Reading user credentials...")
            response = [usernameSaved!, passwordSaved!, rememberSaved!]
        }
        return response
    }
    
    func isKeyExistsInUserDefaults(key:[String]) -> Bool {
        var response = true
        for item in key {
            if (UserDefaults.standard.object(forKey: item) != nil) == false {
                response = false
            }
        }
        return response
    }
    
    // Transfer data to next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromLoginToAttractionSegue" {
            let barViewControllers = segue.destination as! UITabBarController
            let attractionScreen = barViewControllers.viewControllers?[0] as! AttractionScreen
            attractionScreen.userAccount = self.userAccount
        }
    }
    
    // Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        // Check if user is registered
        if self.isRegistered() == true {
            
            // Save credentials if necessary
            if (self.rememberMe.isOn == true) {
                print("Saving...")
                self.rememberCredential = "yes"
                self.writeToUserDefaults()
            } else {
                self.removeFromUserDefaults()
            }
            
            // Create object and transfer data
            self.userAccount.username = username.text!
            self.userAccount.password = password.text!
            performSegue(withIdentifier: "fromLoginToAttractionSegue", sender: nil)
            
        // If user is not registered, show alert
        } else {
             let box = UIAlertController(title:"USER NOT REGISTERED",
                                         message:"Please register a new account or try again",
                                         preferredStyle: .alert);
             
             box.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
             self.present(box, animated: true)
        }
    }
    
}

