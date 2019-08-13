//
//  RepoIssuesViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class RepoIssuesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var issues: [IssueResponse] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private var repository: String!
    private let colums = ["bug", "design", "feature", "networking"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private func getIssue(with label: String) -> [IssueResponse] {
        var outputArray: [IssueResponse] = []
        
        // For each issues in repository
        for issue in issues {
            // Checks if issue has labels
            if let issueResponse = issue.labels {
                // Itterates through labels
                for issueLabel in issueResponse {
                    // If label is as specified in function call
                    if issueLabel.name == label {
                        // Adds to array
                        outputArray.append(issue)
                    }
                }
            }
        }

        return outputArray
    }
}

extension RepoIssuesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.labelName.text = colums[indexPath.row]
        cell.setIssues(issuesArray: getIssue(with: colums[indexPath.row]))
        return cell
    }
    
}

extension RepoIssuesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = self.view.safeAreaLayoutGuide.layoutFrame
        return CGSize(width: frame.width, height: frame.height)
    }
}
