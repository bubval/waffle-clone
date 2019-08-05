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
    let loginManager = AuthenticationManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAccessToken()
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let authorizationUrl = loginManager.buildLoginURL(with: Scopes.allCases , allowSignup: false)
        UIApplication.shared.open(authorizationUrl)
    }
    
    private func validateAccessToken() {
        loginManager.isValidToken() { (success) in
            if success {
                DispatchQueue.main.async {
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepoViewController") as? RepositoryViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}
