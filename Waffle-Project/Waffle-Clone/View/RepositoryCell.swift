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
    private var repository: RepositoryResponse! {
        didSet {
            repositoryName.text = repository.name
        }
    }
    
    func setRepository(_ repo: RepositoryResponse) {
        self.repository = repo
    }
}
