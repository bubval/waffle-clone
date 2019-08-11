//
//  ViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 18.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController {
    private let repoManager = RepositoryManager()
    private let userManager = UserManager()
    private var repositories = [RepositoryResponse]()
    private var user: String!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // This is ugly. Can I use this as a part of the authentication validation, then save it in UserDefaults. My concern in not doing so now is saving the username of a user (NOT PW) in a non-secure location.
        getUser() { (user) in
            if let user = user {
                self.user = user.login
            } else {
                let alert = Alert.showBasicAlert(with: "Error", message: "Ambiguous user.") {_ in
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                        self.present(vc, animated: false, completion: nil)
                    }
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }

        }
        getRepositories() { (repositories) in
            if let repositories = repositories {
                self.repositories = repositories
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                let alert = Alert.showBasicAlert(with: "Error", message: "Repositories could not be loaded. You will be redirected to login") {_ in
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                        self.present(vc, animated: false, completion: nil)
                    }
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - Networking

extension RepositoryViewController {
    
    private func getUser(completion: @escaping ((_ user: BasicUserResponse?) ->())) {
        userManager.getBasic() { (response, error) in
            guard error == nil else {
                return completion(nil)
            }
            
            if let response = response {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    private func getRepositories(completion: @escaping ((_ repositories: [RepositoryResponse]?) ->())) {
        repoManager.repositories { (response, error) in
            guard error == nil else {
                return completion(nil)
            }
            
            if let response = response {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
}

// MARK: - UITableView

extension RepositoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryCell
        cell.setRepository(repositories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepoIssuesViewController") as? RepoIssuesViewController {
            vc.user = self.user
            vc.repository = self.repositories[indexPath.row].name
            navigationController!.pushViewController(vc, animated: true)
        }
    }
}
