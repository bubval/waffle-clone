//
//  RepoIssuesViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {
    
    // MARK: - Properties & Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var issues: [IssueResponse] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    weak var delegate: ProjectCardDelegate?
    private var repository: String!
    // This is just a placeholder variable to control the number and type of project cards
    private let labelManager = LabelManager()
    private let columns = LabelManager.defaultLabels.map{$0.name}
    
    // MARK: - App Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showSpinner(onView: self.view)
        self.getIssues() { (issues) in
            guard issues != nil else {
                let alert = Alert.showBasicAlert(with: "Error", message: "Issues could not be loaded. You will be redirected to repositories.") { _ in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            if let issues = issues {
                self.issues = issues
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.collectionView.reloadData()
                }
            }
        }
        
        self.checkIfDefaultLabelsExist()
        self.issueCategorization()

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
    
    // MARK: - Public Functions
    
    func setRepository(to repository: String) {
        self.repository = repository
    }
}

// MARK: - Label Management

extension ProjectViewController {
    private func getAllRepositoryLabels(completion: @escaping ((_ label: [LabelResponse]?) ->())) {
        if let username = AuthenticationManager.username {
            self.labelManager.get(owner: username, repository: self.repository) { (response, error) in
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
    
    private func createRepositoryLabel(label: LabelResponse, completion: @escaping ((_ label: LabelResponse?) ->())) {
        if let username = AuthenticationManager.username{
            self.labelManager.post(owner: username, repository: self.repository, label: label) { (response, error) in
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
    
    private func checkIfDefaultLabelsExist() {
        self.getAllRepositoryLabels { (allLabels) in
            if let allLabels = allLabels {
                for defaultLabel in LabelManager.defaultLabels {
                    if !allLabels.contains(where: {$0 == defaultLabel}) {
                        self.createRepositoryLabel(label: defaultLabel) { (labelResponse) in
                            if let labelResponse = labelResponse {
                                print("Label created: \(labelResponse)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}

// MARK: - Issue Categorization

extension ProjectViewController {
    
    private func issueCategorization() {
        getIssues { (allIssues) in
            if let allIssues = allIssues {
                for issue in allIssues {
                    let issueNumber = issue.number
                    print(issueNumber)
                    let issueLabels = issue.labels
                    var defaultLabelIsPresent = false
                    
                    // Checks if any of the default labels are present
                    if let issueLabels = issueLabels {
                        for defaultLabel in LabelManager.defaultLabels {
                            if issueLabels.contains(where: {$0 == defaultLabel}) {
                                defaultLabelIsPresent = true
                            }
                        }
                    }
                    
                    if !defaultLabelIsPresent {
                        // Converts issue label names to an array
                        var issueLabelsStringArray: [String]?
                        if let issueLabels = issueLabels {
                            issueLabelsStringArray = issueLabels.map({
                                (label: LabelResponse) -> String in label.name
                            })
                        }
                        // Converts issue assignees login names to an array
                        var issueAssigneesStringArray: [String]?
                        if let issueAssignees = issue.assignees {
                            issueAssigneesStringArray = issueAssignees.map({
                                (assignee: IssueUser) -> String in assignee.login
                            })
                        }
                        
                        // Recreates old issue
                        let oldIssue = Issue(title: issue.title, body: issue.body, labels: issueLabelsStringArray, assignees: issueAssigneesStringArray)
                        print(oldIssue)
                        // Creates new issue appending the first default label
                        let newIssue = self.addLabel(to: oldIssue, label: LabelManager.defaultLabels[0])
                        print(newIssue)
                        
                        self.updateIssue(id: issueNumber, to: newIssue) { (response) in
                            if let response = response {
                                print("Usse successfully updated")
                                if let index = self.issues.firstIndex(where: {$0.id == response.id}) {
                                    self.issues[index] = response
                                    DispatchQueue.main.async {
                                        self.collectionView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func updateIssue(id: Int, to issue: Issue, completion: @escaping ((_ issue: IssueResponse?) ->())) {
        if let username = AuthenticationManager.username {
            IssueManager(owner: username, repository: self.repository).patch(number: id, issue: issue) { (response, error) in
                guard error == nil else {
                    print("guard error")
                    print(error!)
                    completion(nil)
                    return
                }
                
                if let response = response {
                    completion(response)
                } else {
                    print("no response")
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    private func addLabel(to issue:Issue, label: LabelResponse) -> Issue {
        let labelName = label.name
        var newLabels = issue.labels
        
        if newLabels == nil {
            newLabels = [labelName]
        } else {
            newLabels!.append(labelName)
        }
        
        // I perform a check, so it's save to force newLabels
        let newIssue = Issue(title: issue.title, body: issue.body, labels: newLabels!, assignees: issue.assignees)
        
        return newIssue
    }
    
}

// MARK: - Move Issue To Next Column

extension ProjectViewController {
    
    private func moveToNextColumn(issue: IssueResponse?) {
        let defaultLabels = LabelManager.defaultLabels;
        
        // Converts issue assignees to an array
        var issueAssigneesStringArray: [String]?
        if let issue = issue,
            let issueAssignees = issue.assignees {
            issueAssigneesStringArray = issueAssignees.map({
                (assignee: IssueUser) -> String in assignee.login
            })
        }
        
        // Converts issue label names to an array
        var issueLabelsStringArray: [String]?
        if let issue = issue,
            let issueLabels = issue.labels {
            issueLabelsStringArray = issueLabels.map({
                (label: LabelResponse) -> String in label.name
            })
        }
        // Converts default label names to an array
        var defaultLabelsStringArray = defaultLabels.map({
            (label: LabelResponse) -> String in label.name
        })
        
        // Get index of current issue label and default label
        // Finds which of the labels is overlapping with a default label
        var issueLabelIndex: Int?
        var defaultLabelIndex: Int?
        if let issueLabelsStringArray = issueLabelsStringArray {
            let overlappingIssues = defaultLabelsStringArray.filter{issueLabelsStringArray.contains($0)}
            if (overlappingIssues.count == 1) {
                issueLabelIndex = issueLabelsStringArray.firstIndex(of: overlappingIssues[0])
                defaultLabelIndex = defaultLabelsStringArray.firstIndex(of: overlappingIssues[0])
            }
        }
        
        // Change overlapping index to the next default label
        if let issueLabelIndex = issueLabelIndex,
            let defaultLabelIndex = defaultLabelIndex {
            
            if defaultLabelsStringArray.indices.contains(defaultLabelIndex + 1) {
                issueLabelsStringArray![issueLabelIndex] = defaultLabelsStringArray[defaultLabelIndex + 1]
                print(issueLabelsStringArray!)
            }
        }
        
        
        if let issue = issue {
            let newIssue = Issue(title: issue.title, body: issue.body, labels: issueLabelsStringArray, assignees: issueAssigneesStringArray)
            self.updateIssue(id: issue.number, to: newIssue) { (response) in
                if let response = response {
                    if let index = self.issues.firstIndex(where: {$0.id == response.id}) {
                        self.issues[index] = response
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
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
    func returnIssue(_ issue: IssueResponse) {
        moveToNextColumn(issue: issue)
    }
    
    
    func didPressCell(_ issue: IssueResponse) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "IssueViewController") as? IssueViewController {
        
            self.showSpinner(onView: self.view)
            
            getIssue(with: issue.number) { response in
                guard response != nil else {
                    let alert = Alert.showBasicAlert(with: "Error", message: "Could not load issue.")
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                
                if let response = response {
                    vc.setIssue(to: response)
                    self.removeSpinner()
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
