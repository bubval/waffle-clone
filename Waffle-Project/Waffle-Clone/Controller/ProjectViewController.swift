//
//  RepoIssuesViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {
    
    // MARK: - Properties
    
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
    
    // MARK: - App Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Consult Dido about networking in viewWillAppear vs viewDidLoad
        
        getIssues() { (issues) in
            if let issues = issues {
                self.issues = issues
                print(self.issues)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Project Cards"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }

    private var firstViewDidLayoutCall = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstViewDidLayoutCall {
            UIView.animate(withDuration: 2, animations:  {
                self.collectionView.moveToFrame(contentOffset: 30)
            })
        }
        firstViewDidLayoutCall = false
    }
    
    func setRepository(to repository: String) {
        self.repository = repository
    }
}

// MARK: - Networking

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
    
    private func getIssues(with label: String, completion: @escaping ((_ repositories: [IssueResponse]) ->())) {
        var outputArray: [IssueResponse] = []
        for issue in issues where issue.labels != nil{
            for issueLabel in issue.labels! where issueLabel.name == label {
                outputArray.append(issue)
            }
        }
        completion(outputArray)
    }
    
    private func getIssue(with id: Int, completion: @escaping ((_ issue: IssueResponse?) ->())) {
        if let username = AuthenticationManager.username {
            IssueManager(owner: username, repository: self.repository).get(number: id) { (response, error) in
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

// MARK: - Collection View

extension ProjectViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCardCell", for: indexPath) as! ProjectCardCell
        
        cell.labelName.text = columns[indexPath.row]
        cell.delegate = self
        getIssues(with: columns[indexPath.row]) { (issues) in
            cell.setIssues(issuesArray: issues)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let safeArea = self.view.safeAreaFrame
        return CGSize(width: safeArea.width, height: safeArea.height)
    }
    
    // TODO: Consult Dido about prefetch
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            getIssues(with: columns[indexPath.row]) { (issues) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCardCell", for: indexPath) as! ProjectCardCell
                cell.setIssues(issuesArray: issues)
            }
        }
    }
}

// MARK: - ProjectCardDelegate

extension ProjectViewController: ProjectCardDelegate {
    
    func didPressCell(_ issue: IssueResponse) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "IssueViewController") as? IssueViewController {
            getIssue(with: issue.number) { response in
                if let response = response {
                    vc.setIssue(to: response)
                    DispatchQueue.main.async {
                        self.navigationController!.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - Extensions

extension UICollectionView {
    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: false)
    }
}

extension UIView {
    public var safeAreaFrame: CGRect {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide.layoutFrame
        }
        return bounds
    }
}
