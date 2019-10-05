//
//  LoginViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 1.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    let loginManager = LoginManager()
    let authenticationAlert = Alert.showBasicAlert(with: "Error", message: "Authentication failed.")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        loginManager.loginUser() { (success) in
            if !success {
                self.present(self.authenticationAlert, animated: true)
            }
        }
    }
    
    /// If keychain contains a valid access token the user is sent to Repository View Controller. Otherwise, user is shown an error and sent to Login View Controller.
    private func authenticateUser() {
        loginManager.hasValidToken() { (success) in
            if success {
                DispatchQueue.main.async {
                    if let vc = self.storyboard!.instantiateViewController(withIdentifier: "RepoViewController") as? RepositoryViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } 
        }
    }
}
