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
    @IBOutlet weak var issueLabels: UILabel!
    @IBOutlet weak var issueBody: UITextView!
    private var issue: IssueResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: set collectionviewcell delegate to self.

    }

    func setIssue(to issue: IssueResponse) {
        self.issue = issue
    }
}
