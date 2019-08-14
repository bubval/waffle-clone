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
            self.issueBody.isEditable = false
            self.issueBody.text = issue.body
        }
    }
    private var creation: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: issue.createdAt)!
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    private let dateFormat = "yyyy-MM-dd"
    private var issue: IssueResponse!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setIssue(to issue: IssueResponse) {
        self.issue = issue
    }
}
