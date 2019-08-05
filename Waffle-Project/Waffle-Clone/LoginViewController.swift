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
    let loginManager = LoginManager()
    
    // MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAccessToken()
    }
    
    // MARK: - Actions

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if let authorizationUrl = URL(string: buildAuthorizationUrl()) {
            print(authorizationUrl)
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
    private func buildURL(with scopes : [Scopes], allowSignup: Bool) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "github.com"
        urlComponents.path = "/login/oauth/authorize"
        let scopeStrings = scopes.map { $0.rawValue }
        let scopesQueryItem = URLQueryItem(name: "scope", value: scopeStrings.joined(separator: " "))
        let redirectURIQueryItem = URLQueryItem(name: "redirect_uri", value: "\(redirectURL)")
        let allowSignupQueryItem = URLQueryItem(name: "allow_signup", value: "\(allowSignup ? "true" : "false")")
        let clientIDQueryItem = URLQueryItem(name: "client_id", value: clientID)
        urlComponents.queryItems = [scopesQueryItem, redirectURIQueryItem, allowSignupQueryItem, clientIDQueryItem]
        return urlComponents.url!
    }
    
    private func validateAccessToken() {
        loginManager.isValidToken() { (success) in
            if success == true {
                DispatchQueue.main.async {
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}
