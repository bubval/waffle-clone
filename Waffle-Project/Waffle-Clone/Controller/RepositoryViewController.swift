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
    private var repositories: [RepositoryResponse] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    lazy private var signOutButton: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonTapped))
        }()
    private var issues: [IssueResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = "Repositories"
        self.navigationItem.leftBarButtonItem = signOutButton
        
        getRepositories() { (repositories) in
            if let repositories = repositories {
                self.repositories = repositories
            } else {
                let alert = Alert.showBasicAlert(with: "Error", message: "Repositories could not be loaded. You will be redirected to login") {_ in
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                        DispatchQueue.main.async {
                            self.present(vc, animated: false, completion: nil)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func signOutButtonTapped() {
        
        let accessTokenKeychain = Keychain(keychainQueryable: Queryable(service: AuthenticationConstants.accessTokenKey))
        try? accessTokenKeychain.removeAllValues()
        
        if AuthenticationManager.accessToken == nil {
            DispatchQueue.main.async {
                self.navigationController!.popViewController(animated: true)
            }
        } else {
            let alert = Alert.showBasicAlert(with: "Error", message: "Could not log out.")
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Networking

extension RepositoryViewController {
    
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
    
    private func getIssues(for repositoryName: String, completion: @escaping ((_ issues: [IssueResponse]?) ->())) {
        if let username = AuthenticationManager.username {
            IssueManager(owner: username, repository: repositoryName).get { (response, error) in
                guard error == nil else {
                    return completion(nil)
                }
                
                if let response = response {
                    completion(response)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    private func getIssues2(for repositoryName: String, completion: @escaping ((_ issues: [IssueResponse]?)->())) {
        var responses: [IssueResponse]?
        getIssues(for: repositoryName) { (firstIssuesResponse) in
            if let firstIssuesResponse = firstIssuesResponse {
                for issue in firstIssuesResponse {
                    IssueManager(owner: "Bubval", repository: repositoryName).get(number: issue.number) { (response, error) in
                        if let response = response {
                            responses?.append(response)
                        }
                    }
                }
                completion(responses)
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
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProjectViewController") as? ProjectViewController {
            vc.setRepository(to: self.repositories[indexPath.row].name)

            getAllIssues(for: self.repositories[indexPath.row].name) { (allIssues) in
                if let allIssues = allIssues {
                    self.issues = allIssues
                    self.checkIssues(username: AuthenticationManager.username!, repository: self.repositories[indexPath.row].name) { (response) in
                        
                        vc.setIssues(response!)
                    }
                }
            }
            navigationController!.pushViewController(vc, animated: true)
        }
    }
}

extension RepositoryViewController {
    private func getAllIssues(for repositoryName: String, completion: @escaping ((_ issues: [IssueResponse]?) ->())) {
           if let username = AuthenticationManager.username {
               IssueManager(owner: username, repository: repositoryName).get { (response, error) in
                   guard error == nil else {
                       return completion(nil)
                   }
                   
                   if let response = response {
                        completion(response)
                   } else {
                       completion(nil)
                   }
               }
           } else {
               completion(nil)
           }
       }
    
    private func checkIssues(username: String, repository:String, completion: @escaping ((_ issues: [IssueResponse]?) ->())) {
        for issue in self.issues {
            IssueManager(owner: username, repository: repository).get(number: issue.number) { (response, error) in
                if let response = response {
                    if let row = self.issues.firstIndex(where: {$0.number == response.number}) {
                        self.issues[row] = response
                    }
                }
            }
        }
        completion(self.issues)
    }
}
