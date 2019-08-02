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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        print("pressed")
        var url = "https://github.com/login/oauth/authorize"
        url += "?client_id=\(AuthContants.clientId)"
        url += "&redirect_url=\(AuthContants.callbackUrl)"
        url += "&scope=user"
        url += "&state=unguessable"
        url += "&allow_signup=true"
        
        UIApplication.shared.open(URL(string: url)!)
        print(url)
    }

}
