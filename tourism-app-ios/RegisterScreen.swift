//
//  RegisterScreen.swift
//  tourism-app-ios
//
//  Created by user182559 on 11/26/20.
//  Copyright © 2020 Matheus. All rights reserved.
//

import UIKit

class RegisterScreen: UIViewController {

    // Outlets
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    // Variables
    var userAccount = UserAccount()
    var json = JsonEssentials()
    
    // Default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load users
        self.json.users = self.json.loadUsersFromStorage()
        print(self.json.users)

    }
    
    // Functions
    // Transfer data to next screen
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "fromRegisterToAttractionSegue" {
            let barViewControllers = segue.destination as! UITabBarController
            let attractionScreen = barViewControllers.viewControllers?[0] as! AttractionScreen
            attractionScreen.userAccount = self.userAccount
        }
    }
    
    // User Default functions
    func writeToUserDefaults() {
        if (self.txtUsername.text! != "Username") {
            let userDefaults = UserDefaults.standard
            userDefaults.set(self.txtUsername.text!, forKey:"username")
            userDefaults.set(self.txtPassword.text!, forKey:"password")
            print("Saving user credentials...")
        }
    }
    
    func removeFromUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "username")
        userDefaults.removeObject(forKey: "password")
        print("Removing user credentials...")
    }
    
    func readFromUserDefaults() -> [String] {
        var response = ["", ""]
        if (isKeyExistsInUserDefaults(key: "username") == true) {
            let userDefaults = UserDefaults.standard
            let usernameSaved = userDefaults.string(forKey: "username")
            let passwordSaved = userDefaults.string(forKey: "password")
            print("Reading user credentials...")
            response = [usernameSaved!, passwordSaved!]
        }
        return response
    }
    
    func isKeyExistsInUserDefaults(key:String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    // Actions
    @IBAction func registerButtonPressed(_ sender: Any) {
        self.userAccount.username = txtUsername.text!
        self.userAccount.password = txtPassword.text!
        
        // Check if user exists and update registered users
        var userExists = false
        for user in 0...(json.users.count - 1) {
            let name = self.json.users[user].username
            if name == self.userAccount.username {
                self.json.users[user].password = self.userAccount.password
                print("Username updated")
                userExists = true
            }
        }
        if userExists == false {
            self.json.users.append(self.userAccount)
            print("Username registered")
        }
        self.json.saveUserData(program: self.json.users, fileToSaveTo: "registeredUsers")
        
        // Go to the next screen
        performSegue(withIdentifier: "fromRegisterToAttractionSegue", sender: nil)
    }
    
}
