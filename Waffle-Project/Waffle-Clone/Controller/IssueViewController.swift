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
    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var issuePublisher: UILabel!
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
        }
    }
    private var issue: IssueResponse!
    private let dateFormat = "yyyy-MM-dd"
    private var createdAt: String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: issue.createdAt)!
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOutlets()
        //TODO: set collectionviewcell delegate to self.
        
    }
    
    func setIssue(to issue: IssueResponse) {
        self.issue = issue
    }
    
    private func setUpOutlets() {
        issueTitle.text = "\(issue.title) #\(issue.number)"
        issuePublisher.text = "\(issue.user.login) opened this issue on \(createdAt)"
        issueBody.text = issue.body
    }
    
    private func formatDate(from date: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}


