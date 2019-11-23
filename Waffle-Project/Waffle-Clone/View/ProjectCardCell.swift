//
//  CollectionViewCell.swift
//  Waffle-Clone
//
//  Created by Lubo on 13.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit
import QuartzCore

protocol ProjectCardDelegate: class {
    func didPressCell(_ issue: IssueResponse)
    func returnIssue(_ issue: IssueResponse, _ nextCell: Bool)
}

class ProjectCardCell: UICollectionViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                self.tableView.delegate = self
            }
        }
    }
    private var issueArray: [IssueResponse]! {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate: ProjectCardDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let labelText = labelName.text
        let attributedString = NSMutableAttributedString(string: labelText!)
        attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.red, range: NSRange(location: 0, length: labelText!.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: labelText!.count))
        labelName.attributedText = attributedString
        
    }
    
    func setIssues(issuesArray:[IssueResponse]) {
        self.issueArray = issuesArray
    }
}

// MARK: - Table View

extension ProjectCardCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectIssueCell") as! ProjectIssueCell
        cell.setIssue(issueArray[indexPath.row])
        cell.index = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.didPressCell(issueArray[indexPath.row])
            DispatchQueue.main.async {
                print("TABLE VIEW RELOADED")
                self.tableView.reloadData()
            }
        }
    }
}

extension ProjectCardCell: ProjectIssueCellDelegate {
    func onClickCell(index: Int, issue: IssueResponse, nextCell: Bool) {
        delegate?.returnIssue(issue, nextCell)
    }
}
