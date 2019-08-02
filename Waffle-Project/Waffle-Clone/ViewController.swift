//
//  ViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 18.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let authentication = Authentication(username: "bubval", password: "Valkov97")
    let manager = testingRepositoryManager()
    var accessTokenKeychain: Keychain!

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(self.authentication?.getKey())
//        print(self.authentication?.getValue())
        let genericPwdQueryable = GenericPasswordQueryable(service: "MyService")
        accessTokenKeychain = Keychain(keychainQueryable: genericPwdQueryable)

//        do {
//            try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
//        } catch (let e) {
//            print("Saving generic password failed with \(e.localizedDescription).")
//        }
        do {
            let password = try accessTokenKeychain.getValue(for: "genericPassword")
            print(password)
        } catch (let e) {
            print("Reading generic password failed with \(e.localizedDescription).")

        }
        manager.repositories { (response, error) in
            if let response = response {
                print(response)
            } else {
                print(error ?? "error")
            }
        }
    }

    // Just written for the purposes of testing
    public class testingRepositoryManager: GithubManager {
        
        let auth = Authentication(accessToken: "c603597becdf07dac7a17f7430d2fdc97c0d7b92")

        public func get(owner: String, repo: String, completion: @escaping(RepositoryResponse?, Error?) -> Void) {
            let path = "/repos/\(owner)/\(repo)"
            self.get(path: path, completion: completion)
        }
        
        public func repositories(completion: @escaping([RepositoryResponse]?, Error?) -> Void) {
            let path = "/user/repos"
            super.authentication = auth
           
            self.get(path: path, completion: completion)
        }
    }
    
    
}

