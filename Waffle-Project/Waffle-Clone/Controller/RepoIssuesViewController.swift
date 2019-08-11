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
    private let issueManager = IssueManager()
    private var issues = [IssueResponse]()
    var user: String!
    var repository: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getIssues() { (issues) in
            if let issues = issues {
                self.issues = issues
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension RepoIssuesViewController {
    private func getIssues(completion: @escaping ((_ issue: [IssueResponse]?) ->())) {
        issueManager.get(owner: self.user, repository: self.repository) { (response, error) in
            
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

extension RepoIssuesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell") as! IssueTableViewCell
        cell.setIssue(issues[indexPath.row])
        return cell
    }
    
    
}
