//
//  RepoIssuesViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var issues: [IssueResponse] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private var repository: String!
    // This is just a placeholder variable to control the number and type of project cards
    private let columns = ["bug", "design", "feature", "networking"]
    
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

extension ProjectViewController {
    
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
        for issue in issues where issue.labels != nil{
            for issueLabel in issue.labels! where issueLabel.name == label {
                outputArray.append(issue)
            }
        }
        return outputArray
    }
}

extension ProjectViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCardCell", for: indexPath) as! ProjectCardCell
        cell.labelName.text = columns[indexPath.row]
        cell.delegate = self
        cell.setIssues(issuesArray: getIssue(with: columns[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = self.view.safeAreaLayoutGuide.layoutFrame
        return CGSize(width: frame.width, height: frame.height)
    }
}

extension ProjectViewController: ProjectCardDelegate {
    
    func didPressCell(_ issue: IssueResponse) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "IssueViewController") as? IssueViewController {
            vc.setIssue(to: issue)
            navigationController!.pushViewController(vc, animated: true)
        }
    }
}
