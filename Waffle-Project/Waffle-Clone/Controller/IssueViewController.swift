//
//  IssueViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 13.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class IssueViewController: UIViewController {
        
    @IBOutlet weak var authorImage: UIImageView! {
        didSet {
            if let url = URL(string: issue.user.avatarUrl),
            let data = try? Data(contentsOf: url) {
                self.authorImage.image = UIImage(data: data)
            } else {
                self.authorImage.image = UIImage(named: "githubLogo")
            }
        }
    }
    @IBOutlet weak var issueTitle: UILabel! {
        didSet {
            self.issueTitle.text = "\(issue.title) #\(issue.number)"
        }
    }
    @IBOutlet weak var issuePublisher: UILabel! {
        didSet {
            self.issuePublisher.text = "\(issue.user.login) opened this issue on \(creation)"
        }
    }
    @IBOutlet weak var issueLabels: UILabel! {
        didSet {
            if let issueLabels = issue.labels {
                var output = ""
                for issue in issueLabels {
                    output.append(contentsOf: "[\(issue.name)] ")
                }
                self.issueLabels.text = output
            }
        }
    }
    @IBOutlet weak var issueBody: UITextView! {
        didSet {
//            self.issueBody.isEditable = false
            self.issueBody.text = issue.body
        }
    }
    // Converts issue creation date to specified date format.
    private var creation: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: issue.createdAt)!
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private let dateFormat = "yyyy-MM-dd"
    private var issue: IssueResponse!
    @IBOutlet weak var labelCollectionView: UICollectionView!
    @IBOutlet weak var labelCollectionViewLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(issue.title)"
        self.issueBody.isUserInteractionEnabled = false
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
        
        // UICollectionView cell self sizing
        if let flowLayout = labelCollectionViewLayout,
            let labelCollectionView = labelCollectionView {
            // Subtract out 20 points from the margins around the cell
            let width = labelCollectionView.frame.width - 20
            // Need to set estimatedItemSize to toggle self sizing
            flowLayout.estimatedItemSize = CGSize(width: width, height: 22)
        }
    }
    
    func setIssue(to issue: IssueResponse) {
        self.issue = issue
    }
    
    @objc private func editButtonTapped() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem = saveButton
        self.issueBody.isUserInteractionEnabled = true
    }
    
    @objc private func saveButtonTapped() {
        print("SAVED")
       
        let newIssue = Issue(title: issue.title, body: self.issueBody.text, labels: getLabels(from: self.issue), assignees: getAssignees(from: self.issue))
        let issueManager = IssueManager(owner: "bubval", repository: "waffle-clone")
        issueManager.patch(number: self.issue.number, issue: newIssue) { (response, error) in
            guard error == nil else {
                print("ERROR")
                return
            }
            guard response == nil else {
                print("SUCESS")
                self.issue = response
                return
            }
        }
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
        self.issueBody.isUserInteractionEnabled = false
    }
    
    private func getLabels(from issue: IssueResponse) -> [String]? {
        var output: [String]?
        if let issueLabels = issue.labels {
            for label in issueLabels {
                output?.append(label.name)
            }
        }
        return output
    }
    
    private func getAssignees(from issue: IssueResponse) -> [String]? {
        var output: [String]?
        if let issueAssignees = issue.assignees {
            for assignee in issueAssignees {
                output?.append(assignee.login)
            }
        }
        return output
    }
}

extension IssueViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.issue.labels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueLabelCell", for: indexPath) as! IssueLabelCell
        // Force unwrap because if labels == nil then CollectionView has 0 sections
        cell.setLabel(to: issue.labels![indexPath.row])
        return cell
    }
    
}
