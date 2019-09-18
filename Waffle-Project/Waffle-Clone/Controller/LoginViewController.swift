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
    let authenticationManager = AuthenticationManager()
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authenticateUser()	
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If user has never logged in
        if AuthenticationManager.accessToken == nil {
            let alert = Alert.showBasicAlert(with: "Error", message: "Authentication failed.")
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if let authorizationUrl = authenticationManager.buildLoginURL(with: Scopes.allCases) {
            UIApplication.shared.open(authorizationUrl)
        }
    }
    
    /// If keychain contains a valid access token the user is sent to Repository View Controller. Otherwise, user is shown an error and sent to Login View Controller.
    private func authenticateUser() {
        authenticationManager.hasValidToken() { (success) in
            if success {
                if let vc = self.storyboard!.instantiateViewController(withIdentifier: "RepoViewController") as? RepositoryViewController {
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}
