//
//  TableViewCell.swift
//  Waffle-Clone
//
//  Created by Lubo on 5.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var repoImg: UIImageView!
    private var repository: RepositoryResponse! {
        didSet {
            repositoryName.text = repository.name
        }
    }
    
    func setRepository(_ repo: RepositoryResponse) {
        self.repository = repo
        if let openIssueCount = repo.openIssueCount {
            if openIssueCount > 0 {
                self.repoImg.image = UIImage(named: "greenarrow")

            } else {
                self.repoImg.image = UIImage(named: "redarrow")

            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
