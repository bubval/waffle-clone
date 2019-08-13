//
//  CollectionViewCell.swift
//  Waffle-Clone
//
//  Created by Lubo on 13.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
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
    
    func setIssues(issuesArray:[IssueResponse]) {
        self.issueArray = issuesArray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueTableViewCell") as! IssueTableViewCell
        cell.setIssue(issueArray[indexPath.row])
        return cell
    }
    
}
