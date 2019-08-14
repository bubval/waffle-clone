//
//  IssueTableViewCell.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class ProjectIssueCell: UITableViewCell {
    
    @IBOutlet weak var issueTitle: UILabel!
    private var issue: IssueResponse! {
        didSet {
            issueTitle.text = issue.title
        }
    }
    
    func setIssue(_ issue: IssueResponse) {
        self.issue = issue
    }
}
