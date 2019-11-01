//
//  IssueViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 13.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class IssueViewController: UIViewController {
    
    // MARK: - Outlets & Properties
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var issuePublisher: UILabel!
    @IBOutlet weak var issueBody: UITextView!
    @IBOutlet weak var labelCollectionView: UICollectionView!
    @IBOutlet weak var labelCollectionViewLayout: UICollectionViewFlowLayout!
    private var issue: IssueResponse!
    
    private var textViewIsActive: Bool = false {
        didSet {
            if self.textViewIsActive {
                self.issueBody.isEditable = true
                self.issueBody.isScrollEnabled = true
            } else {
                self.issueBody.isEditable = false
                self.issueBody.isScrollEnabled = true
            }
        }
    }
    
    lazy private var editBarButton: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        }()
    lazy private var saveBarButton: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        }()
    
    // MARK: - App Lifecycle
    
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
    
    // MARK: - Public Functions
    
    func setIssue(to issue: IssueResponse) {
        self.issue = issue
    }
    
    // MARK: - Private Functions
    
    private func setUpOutlets(to issue: IssueResponse) {
        
        self.title = "\(issue.title)"
        
        // Labels
        self.issueTitle.text = "\(issue.title) #\(issue.number)"
        self.issuePublisher.text = "\(issue.user.login) opened this issue on \(Date.getFormattedDate(date: issue.createdAt))"
        self.issueBody.text = issue.body
        
        // UIImage
        if let url = URL(string: issue.user.avatarUrl),
            let data = try? Data(contentsOf: url) {
            self.authorImage.image = UIImage(data: data)
        } else {
            self.authorImage.image = UIImage(named: "githubLogo")
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
    
    //MARK: - Navigation bar buttons
    
    @objc private func editButtonTapped() {
        self.navigationItem.rightBarButtonItem = saveBarButton
        self.textViewIsActive = true
    }
    
    @objc private func saveButtonTapped() {
        
        self.navigationItem.rightBarButtonItem = editBarButton
        self.showSpinner(onView: self.view)
        self.textViewIsActive = false
        
        let issue = Issue(title: self.issue.title,
                          body: self.issueBody.text,
                          labels: getLabels(from: self.issue),
                          assignees: getAssignees(from: self.issue))
        
        update(to: issue) { issue in
            // Checks for error
            if issue == nil {
                let alert = Alert.showBasicAlert(with: "Error", message: "Could not update issue.") { _ in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            if let issue = issue {
                DispatchQueue.main.async {
                    self.setUpOutlets(to: issue)
                }
            }
            
            self.removeSpinner()
        }
    }
}

// MARK: - Collection View

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

// MARK: - Networking

extension IssueViewController {
    
    // repostiory hardcoded for purposes of testing
    // TODO: Ask Dido how am I supposed to deal with these 2 variable if they're used in 3 or 4 controllers? Passed them around, keep them as globals, keep them in UD/KC?
    private func update(to issue: Issue, completion: @escaping ((_ issue: IssueResponse?) ->())) {
        if let username = AuthenticationManager.username {
            IssueManager(owner: username, repository: "waffle-clone").patch(number: self.issue.number, issue: issue) { (issue, error) in
                guard error == nil else {
                    completion(nil)
                    return
                }
                
                if let issue = issue {
                    self.issue = issue
                    completion(issue)
                }
            }
        } else {
            completion(nil)
        }
    }
}

// MARK: - Date extension

extension Date {
    
    static func getFormattedDate (date: String , from oldFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ", to newFormat: String = "MMM dd, yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = oldFormat
        let date: Date? = dateFormatter.date(from: date)
        dateFormatter.dateFormat = newFormat
        
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return "N/A"
        }
    }
}
