//
//  IssueTableViewCell.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    private var issue: IssueResponse! {
        didSet {
            issueTitle.text = issue.title
        }
    }
    @IBOutlet weak var issueTitle: UILabel!
    
    func setIssue(_ issue: IssueResponse) {
        self.issue = issue
        print(issue)
    }

}
