//
//  IssueTableViewCell.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

protocol ProjectIssueCellDelegate {
    func onClickCell(index: Int, issue: IssueResponse, nextCell: Bool)
}


class ProjectIssueCell: UITableViewCell {
    
    var delegate: ProjectIssueCellDelegate?
    var index: IndexPath?
    
    
    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBAction func buttonClicked(_ sender: UIButton) {
        delegate?.onClickCell(index: index!.row, issue: issue, nextCell: true)
    }
    @IBAction func buttonClickedPrev(_ sender: UIButton) {
        delegate?.onClickCell(index: index!.row, issue: issue, nextCell: false)
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
