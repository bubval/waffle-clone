//
//  ViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 18.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController {
    private let manager = RepositoryManager()
    private var repositories = [RepositoryResponse]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getRepositories() { (successfullyLoaded, alert) in
            if successfullyLoaded {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    if let alert = alert {
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - Networking

extension RepositoryViewController {
    
    private func getRepositories(completion: @escaping ((_ successfullyLoaded: Bool,_ alert: UIAlertController?) ->())) {
        manager.repositories { (response, error) in
            
            //Dido: could not use 'guard if' because it has to be in DispatchQueue
            
            if let response = response {
                self.repositories = response
                completion(true, nil)
            } else {
                DispatchQueue.main.async {
                    let alert = Alert.showBasicAlert(with: "Error", message: "Repositories could not be loaded. You will be redirected to login") {_ in
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                            self.present(vc, animated: false, completion: nil)
                        }
                    }
                    completion(false, alert)
                }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryCell
        cell.setRepository(repositories[indexPath.row])
        return cell
    }
}
