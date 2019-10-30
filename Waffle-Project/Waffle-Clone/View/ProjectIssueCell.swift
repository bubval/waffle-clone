//
//  IssueTableViewCell.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

protocol TableViewNew {
    func onClickCell(index: Int)
    func onClickCellIssue(issue: IssueResponse)
}


class ProjectIssueCell: UITableViewCell {
    
    var cellDelegate: TableViewNew?
    var index: IndexPath?
    
    
    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBAction func buttonClicked(_ sender: UIButton) {
        cellDelegate?.onClickCell(index: index!.row)
        cellDelegate?.onClickCellIssue(issue: issue)
    }
    private var issue: IssueResponse! {
        didSet {
            issueTitle.text = issue.title
        }
    }
    
    func setIssue(_ issue: IssueResponse) {
        self.issue = issue
    }
}
