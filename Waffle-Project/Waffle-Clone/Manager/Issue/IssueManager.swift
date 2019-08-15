//
//  IssueManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 7.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

class IssueManager: GithubManager {
    private var user: String
    private var repository: String
    
    init(owner: String, repository: String) {
        self.user = owner
        self.repository = repository
    }
    
    /// List of issues for a repository
    ///
    /// - Parameters:
    ///   - completion: Returns IssueResponse if successful, otherwise returns an error
    func get(completion: @escaping([IssueResponse]?, Error?) -> Void) {
        let path = "/repos/\(user)/\(repository)/issues"
        self.get(path: path, completion: completion)
    }
    
    /// Get a single issue
    ///
    /// - Parameters:
    ///   - number: Issue identifier
    ///   - completion: Returns IssueResponse if successful, otherwise returns an error
    func get(number: Int, completion: @escaping(IssueResponse?, Error?) -> Void) {
        let path = "/repos/\(user)/\(repository)/issues/\(number)"
        self.get(path: path, completion: completion)
    }
    
    /// Creates an issue
    ///
    /// - Parameters:
    ///   - issue: Issue object intended to be created
    ///   - completion: Returns IssueResponse if successful, otherwise returns error
    func post(issue: Issue, completion: @escaping(IssueResponse?, Error?) -> Void) {
        let path = "/repos/\(user)/\(repository)/issues"
        self.post(path: path, body: try? JSONEncoder().encode(issue), completion: completion)
    }
    
    /// Partially update an issue
    ///
    /// - Parameters:
    ///   - number: Issue identifier
    ///   - issue: Issue object intended to be created
    ///   - completion: Returns IssueResponse if successful, otherwise returns error
    func patch(number: Int, issue: Issue, completion: @escaping(IssueResponse?, Error?) -> Void)  {
        let path = "/repos/\(user)/\(repository)/issues/\(number)"
        self.patch(path: path, body: try? JSONEncoder().encode(issue), completion: completion)
    }
}
