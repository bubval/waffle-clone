//
//  ViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 18.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController {
    let manager = testingRepositoryManager()
    var repositories = [RepositoryResponse]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getRepositories() { (successfullyLoaded) in
            if successfullyLoaded {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getRepositories(completion: @escaping ((_ successfullyLoaded: Bool) ->())) {
        manager.repositories { (response, error) in
            if let response = response {
                self.repositories = response
                completion(true)
            } else {
                print(error ?? "error")
                completion(false)
            }
        }
    }
}
// MARK: - UITableView

extension RepositoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.setRepository(repositories[indexPath.row])
        return cell
    }
    
}

// Just written for the purposes of testing
class testingRepositoryManager: GithubManager {
    
    public func get(owner: String, repo: String, completion: @escaping(RepositoryResponse?, Error?) -> Void) {
        let path = "/repos/\(owner)/\(repo)"
        self.get(path: path, completion: completion)
    }
    
    public func repositories(completion: @escaping([RepositoryResponse]?, Error?) -> Void) {
        let path = "/user/repos"
        
        self.get(path: path, completion: completion)
    }
}

