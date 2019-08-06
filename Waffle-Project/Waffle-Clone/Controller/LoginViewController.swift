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
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let authorizationUrl = loginManager.buildLoginURL(with: Scopes.allCases , allowSignup: false)
        UIApplication.shared.open(authorizationUrl)
    }
}
