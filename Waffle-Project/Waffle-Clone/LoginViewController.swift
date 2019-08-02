//
//  LoginViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 1.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var loginBtn: UIButton!
    private var keychain = Keychain(keychainQueryable: Queryable(service: "AccessToken"))

    // MARK: - App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if let authorizationUrl = URL(string: buildAuthorizationUrl()) {
            UIApplication.shared.open(authorizationUrl)
        }
    }
    
    // MARK: - Private Functions
    
    private func buildAuthorizationUrl() -> String {
        var url = "https://github.com/login/oauth/authorize"
        url += "?client_id=\(AuthContants.clientId)"
        url += "&redirect_url=\(AuthContants.callbackUrl)"
        url += "&scope=user"
        url += "&state=unguessable"
        url += "&allow_signup=true"
        return url
    }
    
    private func getAccessToken() -> String? {
        do {
            let token = try keychain.getValue(for: "AccessToken")
            return token
        } catch (let e) {
            print("Reading token error \(e.localizedDescription)")
        }
        return nil
    }
}
