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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    let loginManager = LoginManager()
    let authenticationAlert = Alert.showBasicAlert(with: "Error", message: "Authentication failed.")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(hex: "b4edbc").cgColor, UIColor.init(hex: "6CAE75").cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        view.backgroundColor = UIColor.init(hex: "6CAE75")
        
        loginBtn.setTitle("Log in", for: UIControl.State.normal)
        loginBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        loginBtn.backgroundColor = UIColor.clear
        loginBtn.layer.borderWidth = 2.0
        loginBtn.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        loginBtn.layer.cornerRadius = 15.0
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.init(hex: "61a170"),
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth : -4.0,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)]
            as [NSAttributedString.Key : Any]
        titleLabel.attributedText = NSMutableAttributedString(
            string: "GitHub SCRUM",
            attributes: strokeTextAttributes)

        let descriptionString = "Agile Made Easy!"
        let descriptionTextAttribute = [
            NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 18.0)!
        ]
        let descriptionAttrString = NSAttributedString(string: descriptionString, attributes: descriptionTextAttribute)
        descLabel.attributedText = descriptionAttrString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
