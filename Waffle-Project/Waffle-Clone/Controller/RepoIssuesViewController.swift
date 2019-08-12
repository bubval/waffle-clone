//
//  RepoIssuesViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class RepoIssuesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var issues: [IssueResponse] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var repository: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getIssues() { (issues) in
            if let issues = issues {
                self.issues = issues
            } else {
                let alert = Alert.showBasicAlert(with: "Error", message: "Issues could not be loaded. You will be redirected to repositories.") { _ in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setRepository(to repository: String) {
        self.repository = repository
    }
}

extension RepoIssuesViewController {
    
    private func getIssues(completion: @escaping ((_ issue: [IssueResponse]?) ->())) {
        if let username = AuthenticationManager.username {
            IssueManager(owner: username, repository: self.repository).get() { (response, error) in
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
}

extension RepoIssuesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell") as! IssueTableViewCell
        cell.setIssue(issues[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.issues[indexPath.row].title)
    }
}
