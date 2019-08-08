//
//  IssueResponse.swift
//  Waffle-Clone
//
//  Created by Lubo on 29.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

public struct IssueResponse: Codable {
    let id: Int
    let number: Int
    let title: String
    let body: String
    let labels: [LabelResponse]?
    let state: String
    let locked: String
    let comments: Int
    let createdAt: String
    let updatedAt: String
    let closedAt: String?
    let user: IssueUser
    let assignee: IssueUser?
    let assignees: [IssueUser]?
    let closedBy: IssueUser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case number
        case title
        case body
        case labels
        case comments
        case state
        case locked
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case user
        case assignee
        case assignees
        case closedBy = "closed_by"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        number = try values.decode(Int.self, forKey: .number)
        title = try values.decode(String.self, forKey: .title)
        body = try values.decode(String.self, forKey: .body)
        labels = try values.decodeIfPresent([LabelResponse].self, forKey: .labels)
        state = try values.decode(String.self, forKey: .state)
        locked = try values.decode(String.self, forKey: .state)
        comments = try values.decode(Int.self, forKey: .comments)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        updatedAt = try values.decode(String.self, forKey: .updatedAt)
        closedAt = try values.decodeIfPresent(String.self, forKey: .closedAt)
        user = try values.decode(IssueUser.self, forKey: .user)
        assignee = try values.decodeIfPresent(IssueUser.self, forKey: .assignee)
        assignees = try values.decodeIfPresent([IssueUser].self, forKey: .assignees)
        closedBy = try values.decodeIfPresent(IssueUser.self, forKey: .closedAt)
    }
}
