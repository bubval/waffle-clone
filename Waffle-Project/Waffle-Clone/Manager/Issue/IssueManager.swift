//
//  IssueManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 7.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

class IssueManager: GithubManager {
    
    /// List of issues for a repository
    ///
    /// - Parameters:
    ///   - owner: Creator of repository
    ///   - repository: Repository name
    ///   - completion: Returns IssueResponse if successful, otherwise returns an error
    func get(owner: String, repository: String, completion: @escaping([IssueResponse]?, Error?) -> Void) {
        let path = "/repos/\(owner)/\(repository)/issues"
        self.get(path: path, completion: completion)
    }
    
    /// Get a single issue
    ///
    /// - Parameters:
    ///   - number: Issue identifier
    ///   - owner: Creator of repository
    ///   - repository: Repository name
    ///   - completion: Returns IssueResponse if successful, otherwise returns an error
    func get(number: Int, owner: String, repository: String, completion: @escaping(IssueResponse?, Error?) -> Void) {
        let path = "/repos/\(owner)/\(repository)/issues/\(number)"
        self.get(path: path, completion: completion)
    }
    
    /// Creates an issue
    ///
    /// - Parameters:
    ///   - owner: Creator of repository
    ///   - repository: Repository name
    ///   - issue: Issue object intended to be created
    ///   - completion: Returns IssueResponse if successful, otherwise returns error
    func post(owner: String, repository: String, issue: Issue, completion: @escaping(IssueResponse?, Error?) -> Void) {
        let path = "/repos/\(owner)/\(repository)/issues"
        self.post(path: path, body: try? JSONEncoder().encode(issue), completion: completion)
    }
    
    /// Partially update an issue
    ///
    /// - Parameters:
    ///   - owner: Creator of repository
    ///   - repository: Repository name
    ///   - issue: Issue object intended to be created
    ///   - completion: Returns IssueResponse if successful, otherwise returns error
    func patch(owner: String, repository: String, number: Int, issue: Issue, completion: @escaping(IssueResponse?, Error?) -> Void)  {
        let path = "/repos/\(owner)/\(repository)/issues/\(number)"
        self.patch(path: path, body: try? JSONEncoder().encode(issue), completion: completion)
    }
}
