//
//  LoginViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 1.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private let clientID: String = "ea4bd88e013f85f15b8d"
    private let clientSecret: String = "ea2be42b66eaba386af229d08fc98c83bc3c7639"

    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        print("pressed")
        var url = "https://github.com/login/oauth/authorize"
        url += "?client_id=\(clientID)"
        url += "&redirect_url=waffleclone://gitlogin"
        url += "&scope=user"
        url += "&state=unguessable"
        url += "&allow_signup=true"
        
        UIApplication.shared.open(URL(string: url)!)
        print(url)
    }

}
