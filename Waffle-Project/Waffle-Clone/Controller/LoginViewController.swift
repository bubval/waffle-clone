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
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if let authorizationUrl = authenticationManager.buildLoginURL(with: Scopes.allCases) {
            UIApplication.shared.open(authorizationUrl)
        }
    }
}
