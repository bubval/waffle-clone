//
//  IssueViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 13.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class IssueViewController: UIViewController {
        
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var issuePublisher: UILabel!
    @IBOutlet weak var issueBody: UITextView!
    @IBOutlet weak var labelCollectionView: UICollectionView!
    @IBOutlet weak var labelCollectionViewLayout: UICollectionViewFlowLayout!
    private var issue: IssueResponse!
    
    private let dateFormat = "yyyy-MM-dd"
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
    
    lazy private var editBarButton: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
    }()
    lazy private var saveBarButton: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpOutlets(to: self.issue)
        self.navigationItem.rightBarButtonItem = editBarButton

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
    
    private func setUpOutlets(to issue: IssueResponse) {

        self.title = "\(issue.title)"
        
        // Labels
        self.issueTitle.text = "\(issue.title) #\(issue.number)"
        self.issuePublisher.text = "\(issue.user.login) opened this issue on \(creation)"
        self.issueBody.text = issue.body
        print("no user interaction")
        self.issueBody.isUserInteractionEnabled = false

        // UIImage
        if let url = URL(string: issue.user.avatarUrl),
            let data = try? Data(contentsOf: url) {
            self.authorImage.image = UIImage(data: data)
        } else {
            self.authorImage.image = UIImage(named: "githubLogo")
        }
    }

    @objc private func editButtonTapped() {
        self.navigationItem.rightBarButtonItem = saveBarButton
        self.issueBody.isUserInteractionEnabled = true
    }

    @objc private func saveButtonTapped() {
        
        self.navigationItem.rightBarButtonItem = editBarButton
        self.showSpinner(onView: self.view)
        
        let issue = Issue(title: self.issue.title,
                          body: self.issueBody.text,
                          labels: getLabels(from: self.issue),
                          assignees: getAssignees(from: self.issue))
        
        // owner and repostiory hardcoded for purposes of testing
        // TODO: Ask Dido how am I supposed to deal with these 2 variable if they're used in 3 or 4 controllers? Passed them around, keep them as globals, keep them in UD/KC?
        updateIssue(issue: issue) { issueResponse in
            if let issueResponse = issueResponse {
                DispatchQueue.main.async {
                    self.setUpOutlets(to: issueResponse)
                }
            }
            self.removeSpinner()
        }
    }
    
    private func updateIssue(issue: Issue, completion: @escaping ((_ issue: IssueResponse?) ->())) {
        let issueManager = IssueManager(owner: "bubval", repository: "waffle-clone")
        issueManager.patch(number: self.issue.number, issue: issue) { (issue, error) in
            guard error != nil else {
                completion(nil)
                return
            }
            
            if let issue = issue {
                self.issue = issue
                completion(issue)
            }
        }
    }

    // Function written for purposes of testing. In future I will implement tap to select issues from collection view.
    private func getLabels(from issue: IssueResponse) -> [String]? {
        var output: [String]?
        if let issueLabels = issue.labels {
            for label in issueLabels {
                output?.append(label.name)
            }
        }
        return output
    }

    // Function written for purposes of testing. In future I will implement tap to select assignees from collection view.
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
        if let issueLabels = issue.labels {
            cell.setLabel(to: issueLabels[indexPath.row])
        }
        return cell
    }
}
